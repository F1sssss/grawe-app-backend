const PDFDocument = require('pdfkit');
const AppError = require('../AppError');
const logger = require('../../logging/winstonSetup');

function createInvoice(policy) {
  return new Promise((resolve, reject) => {
    try {
      const buffers = [];
      const doc = new PDFDocument({ size: 'A4', margin: 50 });

      doc.on('error', (err) => {
        logger.error('Error during PDF creation: ' + err);
        return reject(new AppError('Error during PDF creation', 500, 'error-creating-pdf'));
      });

      logger.info('Creating PDF...');

      doc.on('data', (buffer) => buffers.push(buffer));

      doc.on('end', () => {
        if (buffers.length === 0) {
          return reject(new AppError('Error during PDF creation', 500, 'error-creating-pdf'));
        }
        resolve({ pdfBuffer: Buffer.concat(buffers), statusCode: 200 });
      });

      const policyData = extractClientPolicyInfo(policy);
      policyData.items = getDistinctObjects(policy, ['datum_dokumenta', 'broj_dokumenta', 'polisa', 'duguje', 'potrazuje', 'saldo']);

      generateHeader(doc);
      generateCustomerInformation(doc, policyData);
      generateInvoiceTable(doc, policyData);

      doc.end();
      logger.info('PDF created successfully');
    } catch (error) {
      logger.error('Unexpected error:', error);
      reject(new AppError('Unexpected error during PDF creation', 500, 'unexpected-error'));
    }
  });
}

function createClientInvoice(client) {
  return new Promise((resolve, reject) => {
    try {
      const doc = new PDFDocument({ size: 'A4', margin: 50 });
      const buffers = [];
      const recapitulation = [];

      doc.on('error', (err) => {
        logger.error('Error during PDF creation:', err);
        return reject(new AppError('Error during PDF creation', 500, 'error-creating-pdf'));
      });

      doc.on('data', (buffer) => buffers.push(buffer));

      doc.on('end', () => {
        if (buffers.length === 0) {
          return reject(new AppError('Error during PDF creation', 500, 'error-creating-pdf'));
        }
        resolve({ pdfBuffer: Buffer.concat(buffers), statusCode: 200 });
      });

      let clientData = extractClientInfo(client);

      for (const entry of client) {
        if (!entry[0].datum_dokumenta) {
          continue;
        }

        clientData.items = getDistinctObjects(entry, [
          'datum_dokumenta',
          'broj_dokumenta',
          'polisa',
          'duguje',
          'potrazuje',
          'saldo',
          'trangrupa1',
          'trangrupa2',
        ]);
        clientData = { ...clientData, ...entry[0] };

        recapitulation.push([
          clientData.broj_polise,
          clientData.naziv_branse,
          clientData.premija,
          clientData.ukupno_placeno,
          clientData.ukupno_duguje,
          clientData.ukupno_dospjelo,
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
    } catch (error) {
      logger.error('Unexpected error:', error);
      reject(new AppError('Unexpected error during PDF creation', 500, 'unexpected-error'));
    }
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
  generateTableRowRecap(doc, invoiceTableTop, 'Polisa', 'Osiguranje', 'Premija', 'Uplaćeno', 'Ukupan dug', 'Dospjelo', 'Nedospjelo');
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
      formatCurrency(item[2]), // Premija
      formatCurrency(item[3]), // Uplaćeno
      formatCurrency(item[4]), // Ukupan dug
      formatCurrency(item[5]), // Nedospjelo
      formatCurrency(item[6]), // Dospjelo
    );

    generateHr(doc, position + 20);
  }

  const subtotalPosition = position + 30;
  doc.font('./src/assets/Roboto-Bold.ttf');
  generateTableRowRecap(
    doc,
    subtotalPosition,
    'TOTAL:',
    '',
    formatCurrency(addUpRecap(invoice, 2)),
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
  let position2 = 0;

  doc.font('./src/assets/Roboto-Bold.ttf');
  generateTableRow(doc, invoiceTableTop, 'Datum Dokumenta', 'Broj Polise', 'Broj Ponude', 'Zaduženo', 'Uplaćeno', 'Saldo');
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
      invoice.broj_ponude,
      formatCurrency(item.duguje),
      formatCurrency(item.potrazuje),
      formatCurrency(item.saldo),
    );

    generateHr(doc, position + 20);

    if (i === invoice.items.length - 1) {
      position2 = (position + 30) % 750 < 20 ? (doc.addPage(), 30) : (position + 30) % 750;

      generateBoldedTableRow(
        doc,
        position2,
        'TOTAL:',
        '',
        '',
        formatCurrency(item.ukupno_zaduzeno),
        formatCurrency(item.ukupno_placeno),
        formatCurrency(item.saldo),
      );

      generateHr(doc, position2 + 20);
    }
  }

  const subtotalPosition = (position2 + 30) % 750 <= 30 ? (doc.addPage(), 30) : (position2 + 30) % 750;
  generateBoldedTableRow(doc, subtotalPosition, '', '', '', 'Ukupni dug', '', formatCurrency(invoice.ukupno_duguje));

  const paidToDatePosition = (subtotalPosition + 20) % 750 <= 20 ? (doc.addPage(), 30) : (subtotalPosition + 20) % 750;
  generateBoldedTableRow(doc, paidToDatePosition, '', '', '', 'Dospjeli dug', '', formatCurrency(invoice.ukupno_dospjelo));

  const duePosition = (paidToDatePosition + 20) % 750 <= 20 ? (doc.addPage(), 30) : (paidToDatePosition + 20) % 750;
  generateBoldedTableRow(doc, duePosition, '', '', '', 'Nedospjeli dug', '', formatCurrency(invoice.ukupno_nedospjelo));
}

function generateTableRow(doc, y, datum_dokumenta, broj_polise, broj_ponude, duguje, potrazuje, saldo) {
  doc
    .fontSize(10)
    .font('./src/assets/Roboto-Regular.ttf')
    .text(datum_dokumenta, 50, y, { encoding: 'utf8' })
    .text(broj_polise, 150, y, { encoding: 'utf8' })
    .text(broj_ponude === 0 ? '-' : broj_ponude, 250, y, { encoding: 'utf8' })
    .text(duguje, 320, y, { width: 90, align: 'right', encoding: 'utf8' })
    .text(potrazuje, 435, y, { width: 50, align: 'right', encoding: 'utf8' })
    .text(saldo, 0, y, { align: 'right', encoding: 'utf8' });
}

function generateBoldedTableRow(doc, y, datum_dokumenta, broj_polise, broj_ponude, duguje, potrazuje, saldo) {
  doc
    .fontSize(9)
    .font('./src/assets/Roboto-Bold.ttf')
    .text(datum_dokumenta, 50, y, { encoding: 'utf8' })
    .text(broj_polise, 150, y, { encoding: 'utf8' })
    .text(broj_ponude === 0 ? '-' : broj_ponude, 250, y, { encoding: 'utf8' })
    .text(duguje, 320, y, { width: 90, align: 'right', encoding: 'utf8' })
    .text(potrazuje, 435, y, { width: 50, align: 'right', encoding: 'utf8' })
    .text(saldo, 0, y, { align: 'right', encoding: 'utf8' });
}

function generateHr(doc, y) {
  doc.strokeColor('#aaaaaa').lineWidth(1).moveTo(50, y).lineTo(550, y).stroke();
}

function formatCurrency(cents) {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'EUR',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(cents / 1);
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

function getDistinctObjects(jsonArray, keys) {
  const distinctObjects = jsonArray.reduce((result, obj) => {
    const key = keys.map((key) => obj[key]).join('|');
    if (!result[key]) {
      result[key] = obj;
    }
    return result;
  }, {});

  return Object.values(distinctObjects).sort((a, b) => {
    const toDate = (dateStr) => {
      const [day, month, year] = dateStr.substring(0, 9).split('.').map(Number);
      return new Date(year, month - 1, day + 1);
    };
    toDate(a.datum_dokumenta) >= toDate(b.datum_dokumenta) ? 1 : -1;
  });
}

module.exports = {
  createInvoice,
  createClientInvoice,
  generateHeader,
};
