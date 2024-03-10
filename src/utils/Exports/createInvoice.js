const PDFDocument = require('pdfkit');
const AppError = require('../AppError');
const logger = require('../../logging/winstonSetup');

function createInvoice(policy) {
  return new Promise(async (resolve, reject) => {
    // Handle errors
    let buffers = [];
    let doc = new PDFDocument({ size: 'A4', margin: 50 });

    doc.on('error', (err) => {
      logger.error('Error during creating PDF', err);
      throw new AppError('Error during creating PDF', 500, 'error-creating-pdf');
    });

    logger.info('Creating PDF...');

    // Collect the PDF buffers
    doc.on('data', (buffer) => {
      buffers.push(buffer);
    });

    // Finalize the PDF document
    doc.on('end', () => {
      if (buffers.length === 0) throw new AppError('Error during creating PDF', 500, 'error-creating-pdf');
      resolve({ pdfBuffer: Buffer.concat(buffers), statusCode: 200 });
    });

    let policyData = extractClientPolicyInfo(policy);
    //console.log(getDistinctObjects(policy[0], ['datum_dokumenta', 'broj_dokumenta', 'polisa', 'duguje', 'potrazuje', 'saldo']));
    policyData.items = getDistinctObjects(policy, ['datum_dokumenta', 'broj_dokumenta', 'polisa', 'duguje', 'potrazuje', 'saldo']);

    generateHeader(doc);
    generateCustomerInformation(doc, policyData);
    generateInvoiceTable(doc, policyData);
    //generateFooter(doc);

    doc.end();

    logger.info('PDF created');
  });
}

function createClientInvoice(client) {
  return new Promise(async (resolve, reject) => {
    let doc = new PDFDocument({ size: 'A4', margin: 50 });
    let buffers = [];
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

    for (let i = 0; i < client.length; i++) {
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

    clientData = [];
    doc.end();
  });
}

function generateHeader(doc) {
  doc
    .image('./src/assets/Grawe.png', 50, 45, { width: 200 })
    .fillColor('#444444')
    .fontSize(20)
    .fontSize(10)
    .font('./src/assets/Roboto-Regular.ttf')
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

  doc.fillColor('#444444').fontSize(10).text(invoice.naziv_branse, 300, 170, { align: 'right' });

  generateHr(doc, 185);

  const customerInformationTop = 190;

  doc
    .fontSize(8)
    .text('Broj Polise:', 420, customerInformationTop)
    .font('./src/assets/Roboto-Bold.ttf')
    .text(invoice.broj_polise, 500, customerInformationTop, { align: 'right' })
    .font('./src/assets/Roboto-Regular.ttf')
    .text('Pocetak osiguranja:', 420, customerInformationTop + 15)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.pocetak_osiguranja, 500, customerInformationTop + 15, { align: 'right' })
    .font('./src/assets/Roboto-Regular.ttf')
    .text('Kraj osiguranja:', 420, customerInformationTop + 30)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.istek_osiguranja, 500, customerInformationTop + 30, { align: 'right' })
    .font('./src/assets/Roboto-Regular.ttf')
    .text('Premija:', 420, customerInformationTop + 45)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(formatCurrency(invoice.premija), 500, customerInformationTop + 45, { align: 'right' })
    .font('./src/assets/Roboto-Regular.ttf')
    .text('Nacin placanja:', 420, customerInformationTop + 60)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.nacin_placanja, 420, customerInformationTop + 60, { align: 'right' })
    .font('./src/assets/Roboto-Regular.ttf')

    .fontSize(9)
    .font('./src/assets/Roboto-Bold.ttf')
    .text(invoice.clientInfo.name, 50, customerInformationTop)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.clientInfo.address, 50, customerInformationTop + 15)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.clientInfo.place, 50, customerInformationTop + 30)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.clientInfo.phone1 === '' ? invoice.clientInfo.phone2 : invoice.clientInfo.phone1, 50, customerInformationTop + 45)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.clientInfo.email, 50, customerInformationTop + 60)
    .font('./src/assets/Roboto-Regular.ttf')
    .moveDown();

  generateHr(doc, 270);
}
function generateCustomerRecapInformation(doc, invoice) {
  doc.fillColor('#444444').fontSize(14).text('REKAPITULACIJA', 50, 160);
  generateHr(doc, 185);

  const customerInformationTop = 190;

  doc
    .fontSize(9)
    .font('./src/assets/Roboto-Bold.ttf')
    .text(invoice.clientInfo.name, 50, customerInformationTop)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.clientInfo.address, 50, customerInformationTop + 15)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.clientInfo.place, 50, customerInformationTop + 30)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.clientInfo.phone1 === '' ? invoice.clientInfo.phone2 : invoice.clientInfo.phone1, 50, customerInformationTop + 45)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(invoice.clientInfo.email, 50, customerInformationTop + 60)
    .font('./src/assets/Roboto-Regular.ttf')
    .moveDown();

  generateHr(doc, 270);
}

function generateInvoiceTableRecap(doc, invoice) {
  let i;
  const invoiceTableTop = 330;
  let position = 0;

  doc.font('./src/assets/Roboto-Bold.ttf');
  generateTableRowRecap(doc, invoiceTableTop, 'Polisa', 'Osiguranje', 'Premija', 'Zaduženo', 'Plaćeno', 'Dospjelo', 'Nedospjelo');
  generateHr(doc, invoiceTableTop + 20);
  doc.font('./src/assets/Roboto-Regular.ttf');

  for (i = 0; i < invoice.length; i++) {
    const item = invoice[i];
    position = (invoiceTableTop + i * 30) % 690;
    position = position < 30 ? (doc.addPage(), 30) : position + 30;

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

  const subtotalPosition = position + 30;
  doc.font('./src/assets/Roboto-Bold.ttf');
  generateTableRowRecap(
    doc,
    subtotalPosition,
    '',
    '',
    'Ukupno',
    formatCurrency(addUpRecap(invoice, 3)),
    formatCurrency(addUpRecap(invoice, 4)),
    formatCurrency(addUpRecap(invoice, 5)),
    formatCurrency(addUpRecap(invoice, 6)),
  );
}

function addUpRecap(invoice, position) {
  let i;
  let ukupno = 0;

  for (i = 0; i < invoice.length; i++) {
    const item = invoice[i];
    ukupno += item[position];
  }

  return ukupno;
}

function generateTableRowRecap(doc, y, polisa, osiguranje, premija, duguje, potrazuje, saldo, dospjelo, nedospjelo) {
  doc
    .fontSize(8)
    .text(polisa, 50, y)
    .text(osiguranje, 100, y)
    .text(premija, 300, y, { encoding: 'utf8' })
    .text(duguje, 350, y, { encoding: 'utf8' })
    .text(potrazuje, 400, y, { encoding: 'utf8' })
    .text(saldo, 450, y, { encoding: 'utf8' })
    .text(dospjelo, 500, y, { encoding: 'utf8' })
    .text(nedospjelo, 550, y, { width: 90, align: 'right', encoding: 'utf8' });
}

function generateInvoiceTable(doc, invoice) {
  let i;
  const invoiceTableTop = 330;

  doc.font('./src/assets/Roboto-Bold.ttf');
  generateTableRow(doc, invoiceTableTop, 'Datum Dokumenta', 'Broj Polise', 'Zaduženo', 'Uplaćeno', 'Saldo');
  generateHr(doc, invoiceTableTop + 20);
  doc.font('./src/assets/Roboto-Regular.ttf');

  for (i = 0; i < invoice.items.length; i++) {
    const item = invoice.items[i];
    let position = (invoiceTableTop + i * 30) % 750;
    position = position < 30 ? (doc.addPage(), 30) : position + 30;

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

  const subtotalPosition = (invoiceTableTop + (i + 1) * 30) % 750;
  generateTableRow(doc, subtotalPosition, '', '', 'Ukupno dospjelo', '', formatCurrency(invoice.ukupno_dospjelo));

  const paidToDatePosition = (subtotalPosition + 20) % 750;
  generateTableRow(doc, paidToDatePosition, '', '', 'Ukupno plaćeno', '', formatCurrency(invoice.ukupno_placeno));

  const duePosition = (paidToDatePosition + 20) % 750;
  generateTableRow(doc, duePosition, '', '', 'Dospjeli dug', '', formatCurrency(invoice.ukupno_duguje));

  const totalRemaining = (duePosition + 20) % 750;
  generateTableRow(doc, totalRemaining, '', '', 'Ukupno nedospjelo', '', formatCurrency(invoice.ukupno_nedospjelo));
}

function generateTableRow(doc, y, datum_dokumenta, broj_polise, duguje, potrazuje, saldo) {
  doc
    .fontSize(10)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(datum_dokumenta, 50, y, { encoding: 'utf8' })
    .text(broj_polise, 150, y, { encoding: 'utf8' })
    .text(duguje, 320, y, { width: 90, align: 'right', encoding: 'utf8' })
    .text(potrazuje, 435, y, { width: 50, align: 'right', encoding: 'utf8' })
    .text(saldo, 0, y, { align: 'right', encoding: 'utf8' });
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
      email: client[0][0].email,
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
      email: client[0].email,
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

  return Object.values(distinctObjects).sort((a, b) => (a.datum_dokumenta >= b.datum_dokumenta ? 1 : -1));
}

module.exports = {
  createInvoice,
  createClientInvoice,
  getDistinctObjects,
};
