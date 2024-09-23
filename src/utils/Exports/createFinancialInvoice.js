const PDFDocument = require('pdfkit');
const AppError = require('../AppError');
const logger = require('../../logging/winstonSetup');
const { generateHeader } = require('./createInvoice');

function createClientInvoice(client) {
  return new Promise(async (resolve, reject) => {
    try {
      let clientData = client.finHistory;

      clientData['ukupno_dospjelo'] = client.finInfo.ukupno_dospjelo;
      clientData['ukupno_nedospjelo'] = client.finInfo.ukupno_nedospjelo;

      let doc = new PDFDocument({ size: 'A4', margin: 50 });
      let buffers = [];

      // Handle errors
      doc.on('error', () => {
        throw new AppError('Error during creating PDF', 500, 'error-creating-pdf');
      });

      // Collect the PDF buffers
      doc.on('data', (buffer) => {
        buffers.push(buffer);
      });

      // Finalize the PDF document
      doc.on('end', () => {
        if (buffers.length === 0) throw new AppError('Error during creating PDF', 500, 'error-creating-pdf');
        resolve({ pdfBuffer: Buffer.concat(buffers), statusCode: 200 });
      });

      generateHeader(doc);
      generateCustomerInformation(doc, client.info, clientData[0].datum_od, clientData[0].datum_do);
      generateInvoiceTable(doc, clientData);

      doc.end();
    } catch (error) {
      logger.error(`Error creating PDF: ${error.message}`);
      reject(new AppError('Error creating PDF', 500, 'error-creating-pdf'));
    }
  });
}
function generateHr(doc, y) {
  doc.strokeColor('#aaaaaa').lineWidth(1).moveTo(50, y).lineTo(550, y).stroke();
}

function generateCustomerInformation(doc, invoice, datum_od, datum_do) {
  doc.fillColor('#444444').fontSize(14).text('KONTO KARTICA', 50, 160);
  doc
    .fillColor('#444444')
    .fontSize(10)
    .text('FINANSIJSKA KARTICA ZA PERIOD: ' + datum_od + ' - ' + datum_do, 250, 160, { align: 'right' });

  generateHr(doc, 185);

  const customerInformationTop = 190;

  doc
    .fontSize(9)
    .font('./src/assets/Roboto-Bold.ttf')
    .text(invoice.klijent, 50, customerInformationTop)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.adresa, 50, customerInformationTop + 15)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.mjesto, 50, customerInformationTop + 30)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.telefon1 === '' ? invoice.telefon2 : invoice.telefon1, 50, customerInformationTop + 45)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.email, 50, customerInformationTop + 60)
    .font('./src/assets/Roboto-Regular.ttf')
    .moveDown();

  generateHr(doc, 270);
}

function generateInvoiceTable(doc, invoice) {
  let i;
  let position2 = 0;
  const invoiceTableTop = 330;

  doc.font('./src/assets/Roboto-Bold.ttf');
  generateTableRow(doc, invoiceTableTop, 'Datum Dokumenta', 'Broj Polise', 'Broj Ponude', 'Zaduženo', 'Uplaćeno', 'Saldo');
  generateHr(doc, invoiceTableTop + 20);
  doc.font('./src/assets/Roboto-Regular.ttf');

  for (i = 0; i < invoice.length; i++) {
    const item = invoice[i];
    let position = (invoiceTableTop + i * 30) % 750;
    position = position < 30 ? (doc.addPage(), 30) : position + 30;

    generateTableRow(
      doc,
      position,
      item.datum_dokumenta,
      item.broj_dokumenta,
      item.broj_ponude,
      formatCurrency(item.zaduzeno),
      formatCurrency(item.uplaceno),
      formatCurrency(item.saldo),
    );

    generateHr(doc, position + 20);

    if (i === invoice.length - 1) {
      position2 = (position + 30) % 750 <= 30 ? (doc.addPage(), 30) : (position + 30) % 750;

      generateTableRow(
        doc,
        position2,
        'TOTAL:',
        '',
        '',
        formatCurrency(addUpRecap(invoice, 4)),
        formatCurrency(addUpRecap(invoice, 5)),
        formatCurrency(item.saldo),
      );

      generateHr(doc, position2 + 20);
    }
  }

  const subtotalPosition = (position2 + 30) % 750 <= 30 ? (doc.addPage(), 30) : (position2 + 30) % 750;
  generateTableRow(doc, subtotalPosition, '', '', '', 'Ukupni dug', '', formatCurrency(invoice[invoice.length - 1].saldo));

  const paidToDatePosition = (subtotalPosition + 20) % 750 <= 20 ? (doc.addPage(), 30) : (subtotalPosition + 20) % 750;
  generateTableRow(doc, paidToDatePosition, '', '', '', 'Dospjeli dug', '', formatCurrency(invoice.ukupno_dospjelo));

  const duePosition = (paidToDatePosition + 20) % 750 <= 20 ? (doc.addPage(), 30) : (paidToDatePosition + 20) % 750;
  generateTableRow(doc, duePosition, '', '', '', 'Nedospjeli dug', '', formatCurrency(invoice.ukupno_nedospjelo));
}

function generateTableRow(doc, y, datum_dokumenta, broj_polise, broj_ponude, duguje, potrazuje, saldo) {
  doc
    .fontSize(10)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(datum_dokumenta.substring(0, 6) === '01.01.' ? 'PS ' + datum_dokumenta : datum_dokumenta, 50, y, { encoding: 'utf8' })
    .text(broj_polise, 150, y, { encoding: 'utf8' })
    .text(broj_ponude === 0 ? '-' : broj_ponude, 250, y, { encoding: 'utf8' })
    .text(duguje, 320, y, { width: 90, align: 'right', encoding: 'utf8' })
    .text(potrazuje, 435, y, { width: 50, align: 'right', encoding: 'utf8' })
    .text(saldo, 0, y, { align: 'right', encoding: 'utf8' });
}

function formatCurrency(cents) {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'EUR',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(cents / 1);
}
function addUpRecap(invoice, position) {
  let i;
  let ukupno = 0;

  for (i = 0; i < invoice.length; i++) {
    const item = invoice[i];
    const keys = Object.keys(item);
    ukupno += item[keys[position]];
  }

  return ukupno;
}

module.exports = { createClientInvoice };
