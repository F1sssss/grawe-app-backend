const PDFDocument = require('pdfkit');
const AppError = require('./AppError');
let buffers = [];
let doc = new PDFDocument({ size: 'A4', margin: 50 });

function createInvoice(policy) {
  return new Promise(async (resolve, reject) => {
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

    let clientData = extractClientPolicyInfo(policy);
    //console.log(getDistinctObjects(policy[0], ['datum_dokumenta', 'broj_dokumenta', 'polisa', 'duguje', 'potrazuje', 'saldo']));
    clientData.items = getDistinctObjects(policy, ['datum_dokumenta', 'broj_dokumenta', 'polisa', 'duguje', 'potrazuje', 'saldo']);

    generateHeader(doc);
    generateCustomerInformation(doc, clientData);
    generateInvoiceTable(doc, clientData);
    //generateFooter(doc);

    doc.end();
  });
}

function createClientInvoice(client) {
  return new Promise(async (resolve, reject) => {
    let recapitulation = [];

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

    let clientData = extractClientInfo(client);

    for (let i = 0; i <= client[0].length; i++) {
      if (client[i][0].datum_dokumenta === null || !client[i][0].datum_dokumenta) {
        continue;
      }

      clientData.items = getDistinctObjects(client[i], ['datum_dokumenta', 'broj_dokumenta', 'polisa', 'duguje', 'potrazuje', 'saldo']);
      clientData.broj_polise = client[i][0].polisa;
      clientData.pocetak_osiguranja = client[i][0].pocetak_osiguranja;
      clientData.istek_osiguranja = client[i][0].istek_osiguranja;
      clientData.ukupno_dospjelo = client[i][0].ukupno_dospjelo;
      clientData.ukupno_placeno = client[i][0].ukupno_placeno;
      clientData.ukupno_duguje = client[i][0].ukupno_duguje;
      clientData.ukupno_nedospjelo = client[i][0].ukupno_nedospjelo;
      clientData.premija = client[i][0].bruto_polisirana_premija;
      clientData.nacin_placanja = client[i][0].nacin_placanja;
      clientData.naziv_branse = client[i][0].naziv_branse;

      recapitulation.push([
        clientData.broj_polise,
        clientData.naziv_branse,
        clientData.premija,
        clientData.ukupno_dospjelo,
        clientData.ukupno_placeno,
        clientData.ukupno_duguje,
        clientData.ukupno_nedospjelo,
      ]);

      generateHeader(doc);
      generateCustomerInformation(doc, clientData);
      generateInvoiceTable(doc, clientData);
      doc.addPage();
    }

    generateHeader(doc);
    generateCustomerRecapInformation(doc, clientData);
    generateInvoiceTableRecap(doc, recapitulation);

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
    .text(invoice.broj_polise, 500, customerInformationTop, { align: 'right' })
    .font('Helvetica')
    .text('Pocetak osiguranja:', 420, customerInformationTop + 15)
    .font('Helvetica')
    .text(invoice.pocetak_osiguranja, 500, customerInformationTop + 15, { align: 'right' })
    .font('Helvetica')
    .text('Kraj osiguranja:', 420, customerInformationTop + 30)
    .font('Helvetica')
    .text(invoice.istek_osiguranja, 500, customerInformationTop + 30, { align: 'right' })
    .font('Helvetica')
    .text('Premija:', 420, customerInformationTop + 45)
    .font('Helvetica')
    .text(formatCurrency(invoice.premija), 500, customerInformationTop + 45, { align: 'right' })
    .font('Helvetica')
    .text('Nacin placanja:', 420, customerInformationTop + 60)
    .font('Helvetica')
    .text(invoice.nacin_placanja, 500, customerInformationTop + 60, { align: 'right' })
    .font('Helvetica')

    .fontSize(9)
    .font('Helvetica-Bold')
    .text(invoice.clientInfo.name, 50, customerInformationTop)
    .font('Helvetica')
    .text(invoice.clientInfo.address, 50, customerInformationTop + 15)
    .font('Helvetica')
    .text(invoice.clientInfo.place, 50, customerInformationTop + 30)
    .font('Helvetica')
    .text(invoice.clientInfo.phone1 === '' ? invoice.clientInfo.phone2 : invoice.clientInfo.phone1, 50, customerInformationTop + 45)
    .font('Helvetica')
    .text(invoice.clientInfo.email, 50, customerInformationTop + 60)
    .font('Helvetica')
    .moveDown();

  generateHr(doc, 270);
}
function generateCustomerRecapInformation(doc, invoice) {
  doc.fillColor('#444444').fontSize(14).text('REKAPITULACIJA', 50, 160);
  generateHr(doc, 185);

  const customerInformationTop = 190;

  doc
    .fontSize(9)
    .font('Helvetica-Bold')
    .text(invoice.clientInfo.name, 50, customerInformationTop)
    .font('Helvetica')
    .text(invoice.clientInfo.address, 50, customerInformationTop + 15)
    .font('Helvetica')
    .text(invoice.clientInfo.place, 50, customerInformationTop + 30)
    .font('Helvetica')
    .text(invoice.clientInfo.phone1 === '' ? invoice.clientInfo.phone2 : invoice.clientInfo.phone1, 50, customerInformationTop + 45)
    .font('Helvetica')
    .text(invoice.clientInfo.email, 50, customerInformationTop + 60)
    .font('Helvetica')
    .moveDown();

  generateHr(doc, 270);
}

function generateInvoiceTableRecap(doc, invoice) {
  let i;
  const invoiceTableTop = 330;

  doc.font('Helvetica-Bold');
  generateTableRowRecap(doc, invoiceTableTop, 'Polisa', 'Osiguranje', 'Premija', 'Zaduzeno', 'Placeno', 'Dospjelo', 'Nedospjelo');
  generateHr(doc, invoiceTableTop + 20);
  doc.font('Helvetica');

  for (i = 0; i < invoice.length; i++) {
    const item = invoice[i];
    let position = (invoiceTableTop + (i + 1) * 30) % 690;

    position = position < 30 ? (doc.addPage(), 30) : position;

    generateTableRowRecap(
      doc,
      position,
      item[0],
      item[1],
      formatCurrency(item[2]),
      formatCurrency(item[3]),
      formatCurrency(item[4]),
      formatCurrency(item[5]),
      formatCurrency(item[6]),
    );

    generateHr(doc, position + 20);
  }

  const subtotalPosition = invoiceTableTop + (i + 1) * 30;
  doc.font('Helvetica-Bold');
  generateTableRowRecap(doc, subtotalPosition, '', '', 'Ukupno', formatCurrency(invoice.ukupno));
}

function generateTableRowRecap(doc, y, polisa, osiguranje, premija, duguje, potrazuje, saldo, dospjelo, nedospjelo) {
  doc
    .fontSize(8)
    .text(polisa, 50, y)
    .text(osiguranje, 100, y)
    .text(premija, 300, y)
    .text(duguje, 350, y)
    .text(potrazuje, 400, y)
    .text(saldo, 450, y)
    .text(dospjelo, 500, y)
    .text(nedospjelo, 550, y, { width: 90, align: 'right' });
}

function generateInvoiceTable(doc, invoice) {
  let i;
  const invoiceTableTop = 330;

  doc.font('Helvetica-Bold');
  generateTableRow(doc, invoiceTableTop, 'Datum Dokumenta', 'Broj Polise', 'Zaduzeno', 'Uplaceno', 'Saldo');
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
      invoice.broj_polise,
      formatCurrency(item.duguje),
      formatCurrency(item.potrazuje),
      formatCurrency(item.saldo),
    );

    generateHr(doc, position + 20);
  }

  const subtotalPosition = (invoiceTableTop + (i + 1) * 30) % 690;
  generateTableRow(doc, subtotalPosition, '', '', 'Ukupno dospjelo', '', formatCurrency(invoice.ukupno_dospjelo));

  const paidToDatePosition = (subtotalPosition + 20) % 690;
  generateTableRow(doc, paidToDatePosition, '', '', 'Ukupno placeno', '', formatCurrency(invoice.ukupno_placeno));

  const duePosition = (paidToDatePosition + 20) % 690;
  generateTableRow(doc, duePosition, '', '', 'Dospjeli dug', '', formatCurrency(invoice.ukupno_duguje));

  const totalRemaining = (duePosition + 20) % 690;
  generateTableRow(doc, totalRemaining, '', '', 'Ukupno nedospjelo', '', formatCurrency(invoice.ukupno_nedospjelo));
}

function generateTableRow(doc, y, datum_dokumenta, broj_polise, duguje, potrazuje, saldo) {
  doc
    .fontSize(10)
    .font('Helvetica')
    .text(datum_dokumenta, 50, y)
    .text(broj_polise, 150, y)
    .text(duguje, 320, y, { width: 90, align: 'right' })
    .text(potrazuje, 435, y, { width: 50, align: 'right' })
    .text(saldo, 0, y, { align: 'right' });
}

function generateHr(doc, y) {
  doc.strokeColor('#aaaaaa').lineWidth(1).moveTo(50, y).lineTo(550, y).stroke();
}

function formatCurrency(cents) {
  return '€' + (cents / 1).toFixed(2);
}

function extractClientInfo(client) {
  return {
    clientInfo: {
      name: client[0][0].klijent,
      date_of_birth: client[0][0].datum_rodjenja,
      embg_pib: client[0][0]['EMBG/PIB'],
      address: client[0][0].adresa,
      place: client[0][0].mjesto,
      phone1: client[0][0].telefon1,
      phone2: client[0][0].telefon2,
      email: 'placeholder@gmal.com',
    },
    items: [],
    broj_polise: client[0][0].polisa,
    pocetak_osiguranja: client[0][0].pocetak_osiguranja,
    istek_osiguranja: client[0][0].istek_osiguranja,
    ukupno_dospjelo: client[0][0].ukupno_dospjelo,
    ukupno_placeno: client[0][0].ukupno_placeno,
    ukupno_duguje: client[0][0].ukupno_duguje,
    ukupno_nedospjelo: client[0][0].ukupno_nedospjelo,
    premija: client[0][0].bruto_polisirana_premija,
    nacin_placanja: client[0][0].nacin_placanja,
    naziv_branse: client[0][0].naziv_branse,
  };
}

function extractClientPolicyInfo(client) {
  return {
    clientInfo: {
      name: client[0].klijent,
      date_of_birth: client[0].datum_rodjenja,
      embg_pib: client[0]['EMBG/PIB'],
      address: client[0].adresa,
      place: client[0].mjesto,
      phone1: client[0].telefon1,
      phone2: client[0].telefon2,
      email: 'placeholder@gmal.com',
    },
    items: [],
    broj_polise: client[0].polisa,
    pocetak_osiguranja: client[0].pocetak_osiguranja,
    istek_osiguranja: client[0].istek_osiguranja,
    ukupno_dospjelo: client[0].ukupno_dospjelo,
    ukupno_placeno: client[0].ukupno_placeno,
    ukupno_duguje: client[0].ukupno_duguje,
    ukupno_nedospjelo: client[0].ukupno_nedospjelo,
    premija: client[0].bruto_polisirana_premija,
    nacin_placanja: client[0].nacin_placanja,
    naziv_branse: client[0].naziv_branse,
  };
}

function formatDate(date) {
  const day = date.getDate();
  const month = date.getMonth() + 1;
  const year = date.getFullYear();

  return day + '/' + month + '/' + year;
}

function getDistinctObjects(jsonArray, keys) {
  const distinctObjects = jsonArray.reduce((result, obj) => {
    const key = keys.map((key) => obj[key]).join('|');
    if (!result[key]) {
      result[key] = obj;
    }
    return result;
  }, {});

  return Object.values(distinctObjects);
}

module.exports = {
  createInvoice,
  createClientInvoice,
};
