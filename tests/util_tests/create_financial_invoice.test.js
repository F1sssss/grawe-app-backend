const { createClientInvoice } = require('../../utils/Exports/createFinancialInvoice');
const PDFDocument = require('pdfkit');
const AppError = require('../../utils/AppError');
const logger = require('../../logging/winstonSetup');

jest.mock('pdfkit');
jest.mock('../../utils/AppError');
jest.mock('../../logging/winstonSetup');
jest.mock('./../../utils/Exports/createInvoice', () => ({
  generateHeader: jest.fn(),
}));

describe('createClientInvoice', () => {
  let mockDoc;

  beforeEach(() => {
    mockDoc = {
      on: jest.fn(),
      end: jest.fn(),
      strokeColor: jest.fn().mockReturnThis(),
      lineWidth: jest.fn().mockReturnThis(),
      moveTo: jest.fn().mockReturnThis(),
      lineTo: jest.fn().mockReturnThis(),
      stroke: jest.fn().mockReturnThis(),
      fillColor: jest.fn().mockReturnThis(),
      fontSize: jest.fn().mockReturnThis(),
      text: jest.fn().mockReturnThis(),
      font: jest.fn().mockReturnThis(),
      moveDown: jest.fn().mockReturnThis(),
      addPage: jest.fn().mockReturnThis(),
    };

    PDFDocument.mockImplementation(() => mockDoc);
  });

  it('should create a client invoice successfully', async () => {
    const mockClient = {
      finHistory: [
        {
          datum_od: '01.01.2023',
          datum_do: '31.12.2023',
          datum_dokumenta: '01.01.2023',
          broj_dokumenta: '123',
          broj_ponude: '456',
          zaduzeno: 1000,
          uplaceno: 500,
          saldo: 500,
        },
      ],
      finInfo: {
        ukupno_dospjelo: 300,
        ukupno_nedospjelo: 200,
      },
      info: {
        klijent: 'Test Client',
        adresa: 'Test Address',
        mjesto: 'Test City',
        telefon1: '123456',
        telefon2: '',
        email: 'test@example.com',
      },
    };

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
    expect(mockDoc.end).toHaveBeenCalled();
  });

  it('should handle errors during PDF creation', async () => {
    const mockClient = {
      finHistory: [],
      finInfo: {},
      info: {},
    };

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
