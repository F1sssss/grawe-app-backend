const PDFDocument = require('pdfkit');
const AppError = require('./AppError');
const policyQueries = require('../sql/Queries/PoliciesQueries');

function createInvoice(policy) {
  return new Promise(async (resolve, reject) => {
    let buffers = [];
    let doc = new PDFDocument({ size: 'A4', margin: 50 });

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

    const invoiceData = {
      shipping: {
        name: 'SMN TRANSPORTI DOO',
        address: 'KRIVAULICA,DOBROTA BB',
        city: 'KOTOR',
        country: 'MNE',
        postal_code: 94111,
      },
      items: policy,
      paid: 0,
      broj_polise: 12346,
    };

    generateHeader(doc);
    generateCustomerInformation(doc, invoiceData);
    generateInvoiceTable(doc, invoiceData);
    //generateFooter(doc);

    doc.end();
  });
}

function createClientInvoice(client) {
  return new Promise(async (resolve, reject) => {
    let buffers = [];
    let doc = new PDFDocument({ size: 'A4', margin: 50 });

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

    const clientData = {
      clientInfo: {
        name: 'VERICA JEREMIC',
        date_of_birth: '05.08.1968',
        embg_pib: '0508968288028',
        address: 'UBLI BB',
        place: 'PODGORICA',
        phone1: '069 / 537-632',
        phone2: '',
        email: 'nes @gmail.com',
      },
      items: [],
      paid: 0,
      broj_polise: 12346,
    };

    let invoiceDataCopy = clientData;

    for (let i = 0; i < client[0].length; i++) {
      invoiceDataCopy.items = client[i];
      invoiceDataCopy.broj_polise = client[i][0].polisa;
      generateHeader(doc);
      generateCustomerInformation(doc, invoiceDataCopy);
      generateInvoiceTable(doc, invoiceDataCopy);
      doc.addPage();
    }

    doc.end();
  });
}

function generateHeader(doc) {
  doc
    .image('./src/assets/Grawe.png', 50, 45, { width: 200 })
    .fillColor('#444444')
    .fontSize(20)
    .fontSize(10)
    .text('Grawe neživotno osiguranje a.d.', 200, 30, { align: 'right' })
    .text('Josipa Broza Tita 23a', 200, 45, { align: 'right' })
    .text('81000 Podgorica', 200, 60, { align: 'right' })
    .text('T  +382 20 657 300', 200, 75, { align: 'right' })
    .text('F  +382 20 657 301', 200, 90, { align: 'right' })
    .text('E  info.nezivot@grawe.me', 200, 105, { align: 'right' })
    .moveDown();
}

function generateCustomerInformation(doc, invoice) {
  doc.fillColor('#444444').fontSize(14).text('KONTO KARTICA', 50, 160);

  generateHr(doc, 185);

  const customerInformationTop = 190;

  doc
    .fontSize(8)
    .text('Broj Polise:', 420, customerInformationTop)
    .font('Helvetica-Bold')
    .text(invoice.broj_polise, 500, customerInformationTop)
    .font('Helvetica')
    .text('Pocetak osiguranja:', 420, customerInformationTop + 15)
    .font('Helvetica')
    .text(formatDate(new Date()), 500, customerInformationTop + 15)
    .font('Helvetica')
    .text('Kraj osiguranja:', 420, customerInformationTop + 30)
    .font('Helvetica')
    .text(formatDate(new Date()), 500, customerInformationTop + 30)
    .font('Helvetica')
    .text('Premija:', 420, customerInformationTop + 45)
    .font('Helvetica')
    .text(formatCurrency(invoice.subtotal - invoice.paid), 500, customerInformationTop + 45)
    .font('Helvetica')

    .font('Helvetica-Bold')
    .text(invoice.clientInfo.name, 50, customerInformationTop)
    .font('Helvetica')
    .text(invoice.clientInfo.address, 50, customerInformationTop + 12)
    .font('Helvetica')
    .text(invoice.clientInfo.place, 50, customerInformationTop + 24)
    .font('Helvetica')
    .text(invoice.clientInfo.phone1, 50, customerInformationTop + 36)
    .font('Helvetica')
    .text(invoice.clientInfo.phone2, 50, customerInformationTop + 48)
    .font('Helvetica')
    .text(invoice.clientInfo.email, 50, customerInformationTop + 60)
    .font('Helvetica')
    .moveDown();

  generateHr(doc, 270);
}

function generateInvoiceTable(doc, invoice) {
  let i;
  const invoiceTableTop = 330;

  doc.font('Helvetica-Bold');
  generateTableRow(doc, invoiceTableTop, 'Datum Dokumenta', 'Broj Dokumenta', 'Broj Polise', 'Vid', 'Opis Knjizenja', 'Duguje', 'Potrazuje', 'Saldo');
  generateHr(doc, invoiceTableTop + 20);
  doc.font('Helvetica');

  for (i = 0; i < invoice.items.length; i++) {
    const item = invoice.items[i];
    let position = (invoiceTableTop + (i + 1) * 30) % 690;

    position = position < 30 ? (doc.addPage(), 30) : position;

    generateTableRow(
      doc,
      position,
      item.datum_dokumenta,
      item.broj_dokumenta,
      item.broj_ponude,
      item.vid,
      item.opis_knjizenja,
      formatCurrency(item.duguje),
      formatCurrency(item.potrazuje),
      formatCurrency(item.saldo),
    );

    generateHr(doc, position + 20);
  }

  const subtotalPosition = (invoiceTableTop + (i + 1) * 30) % 690;
  generateTableRow(doc, subtotalPosition, '', '', '', '', 'Ukupno dospjelo', '', '', formatCurrency(invoice.duguje));

  const paidToDatePosition = (subtotalPosition + 20) % 690;
  generateTableRow(doc, paidToDatePosition, '', '', '', '', 'Ukupno placeno', '', '', formatCurrency(invoice.potrazuje));

  const duePosition = (paidToDatePosition + 20) % 690;
  generateTableRow(doc, duePosition, '', '', '', '', 'Dospjeli dug', '', '', formatCurrency(invoice.saldo));

  const totalRemaining = (duePosition + 20) % 690;
  generateTableRow(doc, totalRemaining, '', '', '', '', 'Ukupno nedospjelo', '', '', formatCurrency(invoice.saldo));
}

function generateTableRow(doc, y, datum_dokumenta, broj_dokumenta, broj_ponude, vid, opis_knjizenja, duguje, potrazuje, saldo) {
  doc
    .fontSize(10)
    .font('Helvetica')
    .text(datum_dokumenta, 50, y)
    .text(broj_dokumenta, 140, y)
    .text(broj_ponude, 220, y)
    .text(vid, 290, y)
    .text(opis_knjizenja, 335, y, { width: 90 })
    .text(duguje, 400, y, { width: 50, align: 'right' })
    .text(potrazuje, 450, y, { width: 50, align: 'right' })
    .text(saldo, 0, y, { align: 'right' });
}

function generateHr(doc, y) {
  doc.strokeColor('#aaaaaa').lineWidth(1).moveTo(50, y).lineTo(550, y).stroke();
}

function formatCurrency(cents) {
  return '€' + (cents / 100).toFixed(2);
}

function formatDate(date) {
  const day = date.getDate();
  const month = date.getMonth() + 1;
  const year = date.getFullYear();

  return day + '/' + month + '/' + year;
}

module.exports = {
  createInvoice,
  createClientInvoice,
};
