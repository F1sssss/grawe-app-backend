const { createInvoice, createClientInvoice } = require('../../src/utils/Exports/createInvoice');
const PDFDocument = require('pdfkit');
const AppError = require('../../src/utils/AppError');

jest.mock('pdfkit');
jest.mock('../../src/utils/AppError');
jest.mock('../../src/logging/winstonSetup');

describe('createInvoice', () => {
  let mockDoc;

  beforeEach(() => {
    mockDoc = {
      on: jest.fn(),
      end: jest.fn(),
      image: jest.fn().mockReturnThis(),
      fillColor: jest.fn().mockReturnThis(),
      fontSize: jest.fn().mockReturnThis(),
      font: jest.fn().mockReturnThis(),
      text: jest.fn().mockReturnThis(),
      moveDown: jest.fn().mockReturnThis(),
    };

    PDFDocument.mockImplementation(() => mockDoc);
  });

  it('should create an invoice successfully', async () => {
    const mockPolicy = [
      {
        klijent: 'ENVER HASHANI',
        datum_rodjenja: null,
        'embg/pib': '0',
        adresa: 'BORDER INSURANCE 1',
        mjesto: 'PODGORICA',
        telefon1: '',
        telefon2: '',
        email: '',
        polisa: 90225865,
        pocetak_osiguranja: '11.08.2022',
        istek_osiguranja: '27.08.2022',
        datum_storna: '27.08.2022',
        premija: 0,
        nacin_placanja: 'godišnje placanje',
        naziv_branse: 'OSIGURANJE OD AUTOODGOVORNISTI',
        bruto_polisirana_premija: 13.76,
        neto_polisirana_premija: 13.76,
        datum_dokumenta: '2022.08.12',
        duguje: 0,
        potrazuje: 15,
        saldo: -15,
        ukupno_dospjelo: 15,
        ukupno_placeno: 15,
        ukupno_duguje: 0,
        ukupno_nedospjelo: 0,
      },
    ];

    mockDoc.on.mockImplementation((event, callback) => {
      if (event === 'data') {
        callback(Buffer.from('test'));
      } else if (event === 'end') {
        callback();
      }
    });

    const result = await createInvoice(mockPolicy);
    expect(result).toEqual({
      pdfBuffer: expect.any(Buffer),
      statusCode: 200,
    });
    expect(PDFDocument).toHaveBeenCalledWith({ size: 'A4', margin: 50 });
  });

  it('should throw an AppError if PDF creation fails', async () => {
    const mockPolicy = [];

    mockDoc.on.mockImplementation((event, callback) => {
      if (event === 'error') {
        callback(new Error('PDF creation failed'));
      }
    });

    try {
      await createInvoice(mockPolicy);
    } catch (e) {
      expect(e).toBeInstanceOf(AppError);
    }
  });
});

describe('createClientInvoice', () => {
  let mockDoc;

  beforeEach(() => {
    mockDoc = {
      on: jest.fn(),
      end: jest.fn(),
      addPage: jest.fn(),
      image: jest.fn().mockReturnThis(),
      fillColor: jest.fn().mockReturnThis(),
      fontSize: jest.fn().mockReturnThis(),
      font: jest.fn().mockReturnThis(),
      text: jest.fn().mockReturnThis(),
      moveDown: jest.fn().mockReturnThis(),
    };

    PDFDocument.mockImplementation(() => mockDoc);
  });
  it('should create a client invoice successfully', async () => {
    const mockClient = [
      [
        {
          klijent: 'VERICA JEREMIĆ',
          datum_rodjenja: '1968-08-05T00:00:00.000Z',
          'embg/pib': '0508968288028',
          adresa: 'UBLI BB',
          mjesto: 'PODGORICA',
          telefon1: '069 / 537-632',
          telefon2: '',
          email: '',
          polisa: 91010329,
          pocetak_osiguranja: '24.05.2022',
          istek_osiguranja: '24.05.2023',
          datum_storna: '24.05.2023',
          nacin_placanja: 'godišnje placanje',
          naziv_branse: 'OSIGURANJE OD AUTOODGOVORNISTI',
          bruto_polisirana_premija: 125.84,
          broj_ponude: 215885,
          datum_dokumenta: '25.05.2022',
          duguje: 125.84,
          potrazuje: 0,
          saldo: 125.84,
          ukupno_zaduzeno: 125.84,
          ukupno_placeno: 125.84,
          ukupno_dospjelo: 0,
          ukupno_nedospjelo: 0,
          ukupno_duguje: 0,
        },
      ],
    ];

    mockDoc.on.mockImplementation((event, callback) => {
      if (event === 'data') {
        callback(Buffer.from('test'));
      } else if (event === 'end') {
        callback();
      }
    });

    const result = await createClientInvoice(mockClient);
    expect(result).toEqual({
      pdfBuffer: expect.any(Buffer),
      statusCode: 200,
    });
    expect(PDFDocument).toHaveBeenCalledWith({ size: 'A4', margin: 50 });
  });

  it('should throw an AppError if PDF creation fails', async () => {
    const mockClient = [];

    mockDoc.on.mockImplementation((event, callback) => {
      if (event === 'error') {
        callback(new Error('PDF creation failed'));
      }
    });
    try {
      await createClientInvoice(mockClient);
    } catch (e) {
      expect(e).toBeInstanceOf(AppError);
    }
  });
});
