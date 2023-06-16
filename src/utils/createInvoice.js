const PDFDocument = require('pdfkit');
const AppError = require('./AppError');
const policyQueries = require('../sql/Queries/PoliciesQueries');

function createInvoice(policy) {
  return new Promise(async (resolve, reject) => {
    let buffers = [];
    let doc = new PDFDocument({ size: 'A4', margin: 50 });

    const invoiceData = {
      shipping: {
        name: 'SMN TRANSPORTI DOO',
        address: 'KRIVAULICA,DOBROTA BB',
        city: 'KOTOR',
        country: 'MNE',
        postal_code: 94111
      },
      items: policy,
      paid: 0,
      broj_polise: 12346
    };

    // Handle errors
    doc.on('error', () => {
      reject(new AppError('Error during creating PDF', 500));
    });

    // Collect the PDF buffers
    doc.on('data', (buffer) => {
      buffers.push(buffer);
    });

    // Finalize the PDF document
    doc.on('end', () => {
      resolve({ pdfBuffer: Buffer.concat(buffers), statusCode: 200 });
    });

    generateHeader(doc);
    generateCustomerInformation(doc, invoiceData);
    generateInvoiceTable(doc, invoiceData);
    //generateFooter(doc);

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

  const customerInformationTop = 200;

  doc
    .fontSize(10)
    .text('Broj Polise:', 50, customerInformationTop)
    .font('Helvetica-Bold')
    .text(invoice.broj_polise, 150, customerInformationTop)
    .font('Helvetica')
    .text('Datum od:', 50, customerInformationTop + 15)
    .text(formatDate(new Date()), 150, customerInformationTop + 15)
    .text('Balance Due:', 50, customerInformationTop + 30)
    .text(formatCurrency(invoice.subtotal - invoice.paid), 150, customerInformationTop + 30)

    .font('Helvetica-Bold')
    .text(invoice.shipping.name, 300, customerInformationTop)
    .font('Helvetica')
    .text(invoice.shipping.address, 300, customerInformationTop + 15)
    .text(invoice.shipping.city + ', ' + invoice.shipping.country, 300, customerInformationTop + 30)
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
      formatCurrency(item.saldo)
    );

    generateHr(doc, position + 20);
  }

  const subtotalPosition = (invoiceTableTop + (i + 1) * 30) % 690;
  generateTableRow(doc, subtotalPosition, '', '', '', '', '', 'Duguje', '', formatCurrency(invoice.duguje));

  const paidToDatePosition = (subtotalPosition + 20) % 690;
  generateTableRow(doc, paidToDatePosition, '', '', '', '', '', 'Potrazuje', '', formatCurrency(invoice.potrazuje));

  const duePosition = (paidToDatePosition + 25) % 690;
  doc.font('Helvetica-Bold');
  generateTableRow(doc, duePosition, '', '', '', '', '', 'Potrazuje', '', formatCurrency(invoice.saldo));
  doc.font('Helvetica');
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
  createInvoice
};
