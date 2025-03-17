const DBConnection = require('../../src/sql/DBConnection');
const ClientQueries = require('../../src/sql/Queries/ClientQueries');
const sql = require('../sql_test');

describe('Clients queries tests', () => {
  beforeAll(() => {
    connection = new DBConnection(sql);
    jest.setTimeout(500000);
  });

  it('should connect to the test database', async () => {
    const originalConnect = connection.connect;
    connection.connect = jest.fn().mockImplementation(async () => {
      await originalConnect.call(connection);
    });

    await connection.connect();
    expect(connection.connect).toHaveBeenCalled();

    connection.connect = originalConnect;
  }, 50000);

  it('should return client info with the correct fields and exact values', async () => {
    //const expectedPoliciesCount = 132; // The expected number of policies
    const expectedClientInfo = {
      klijent: 'RADIO I TELEVIZIJA CRNE GORE ',
      datum_rodjenja: null,
      jmbg_pib: '02020220',
      adresa: 'BULEVAR REVOLUCIJE 19',
      mjesto: 'PODGORICA',
      telefon1: '020234427',
      telefon2: '',
      email: '',
    };

    const result = await ClientQueries.getClientInfo('02020220');

    expect(result.statusCode).toBe(200);

    expect(result.client).toHaveProperty('klijent', expectedClientInfo.klijent);
    expect(result.client).toHaveProperty('datum_rodjenja', expectedClientInfo.datum_rodjenja);
    expect(result.client).toHaveProperty('jmbg_pib', expectedClientInfo.jmbg_pib);
    expect(result.client).toHaveProperty('adresa', expectedClientInfo.adresa);
    expect(result.client).toHaveProperty('mjesto', expectedClientInfo.mjesto);
    expect(result.client).toHaveProperty('telefon1', expectedClientInfo.telefon1);
    expect(result.client).toHaveProperty('telefon2', expectedClientInfo.telefon2);
    expect(result.client).toHaveProperty('email', expectedClientInfo.email);
  });

  it('should return empty client info as the client does not exist', async () => {
    const result = await ClientQueries.getClientInfo('00000000');
    expect(result.client).toEqual({});
  });

  it('should return client history with the correct fields and exact values', async () => {
    const result = await ClientQueries.getClientHistory('02020220', '2019.01.01', '2026.01.01');

    expect(result.statusCode).toBe(200);

    expect(result.client[0]).toHaveProperty('datum_dokumenta');
    expect(result.client[0]).toHaveProperty('polisa');
    expect(result.client[0]).toHaveProperty('broj_dokumenta');
    expect(result.client[0]).toHaveProperty('broj_ponude');
    expect(result.client[0]).toHaveProperty('vid');
    expect(result.client[0]).toHaveProperty('opis_knjizenja');
    expect(result.client[0]).toHaveProperty('duguje');
    expect(result.client[0]).toHaveProperty('potrazuje');
    expect(result.client[0]).toHaveProperty('saldo');
  });

  it('should return empty client history', async () => {
    const result = await ClientQueries.getClientHistory('02020220', '2024.01.01', '2024.01.01');

    expect(result.statusCode).toBe(200);

    expect(result.client).toEqual([]);
  });

  it('should return clients right values for analytical data', async () => {
    const result = await ClientQueries.getClientAnalyticalInfo('02020220', '2024.01.01', '2026.01.01');

    expect(result.statusCode).toBe(200);

    const expectedClientInfo = {
      klijent_bruto_polisirana_premija: 63888.11,
      klijent_neto_polisirana_premija: 62392.41,
      dani_kasnjenja: 0,
      klijent_ukupna_potrazivanja: 0,
      klijent_dospjela_potrazivanja: -5208.48,
    };

    expect(result.statusCode).toBe(200);

    expect(result.client).toHaveProperty('klijent_bruto_polisirana_premija', expectedClientInfo.klijent_bruto_polisirana_premija);
    expect(result.client).toHaveProperty('klijent_neto_polisirana_premija', expectedClientInfo.klijent_neto_polisirana_premija);
    expect(result.client).toHaveProperty('dani_kasnjenja', expectedClientInfo.dani_kasnjenja);
    expect(result.client).toHaveProperty('klijent_ukupna_potrazivanja', expectedClientInfo.klijent_ukupna_potrazivanja);
    expect(result.client).toHaveProperty('klijent_dospjela_potrazivanja', expectedClientInfo.klijent_dospjela_potrazivanja);
    expect(result.client).toHaveProperty('policies', expect.any(Array));
  });

  it('should return empty client analytical info', async () => {
    const result = await ClientQueries.getClientAnalyticalInfo('00000000', '2024.01.01', '2026.01.01');

    expect(result.statusCode).toBe(200);

    expect(result.client).toEqual({ policies: [] });
  });

  it('should return all client info with the correct fields and exact values', async () => {
    const expectedClientInfo = {
      klijent: 'RADIO I TELEVIZIJA CRNE GORE ',
      datum_rodjenja: null,
      'embg/pib': '02020220',
      adresa: 'BULEVAR REVOLUCIJE 19',
      mjesto: 'PODGORICA',
      telefon1: '020234427',
      telefon2: '',
      email: '',
      polisa: 9003537,
      pocetak_osiguranja: '25.07.2024',
      istek_osiguranja: '25.07.2025',
      datum_storna: '25.07.2025',
      nacin_placanja: 'mjesecno plaćanje',
      nacin_placanja_sifra: 6,
      naziv_branse: 'KOL. OSIG. OD NESRECNOG SLUCAJA',
      bruto_polisirana_premija: 20115.0,
      neto_polisirana_premija: 20115.0,
      dani_kasnjenja: 0,
      ukupna_potrazivanja: 10339.64,
      status_polise: 'Aktivna',
      bransa: 9,
      storno_tip: '48',
      uplacena_premija: 9775.36,
      broj_ponude: 0,
      pko_buch_nr: 1,
      datum_dokumenta: '25.07.2024',
      duguje: 3352.5,
      potrazuje: 0.0,
      saldo: 3352.5,
      klijent_bruto_polisirana_premija: 62966.67,
      klijent_neto_polisirana_premija: 61547.03,
      klijent_dani_kasnjenja: 0,
      dospjela_potrazivanja: -3070.36,
      trangrupa1: 'AVE',
      trangrupa2: 'NEU',
      klijent_dospjela_potrazivanja: 0,
      klijent_status_polise: '-',
    };

    const result = await ClientQueries.getAllClientInfoFiltered('02020220', '2024.01.01', '2026.01.01', 1, 1);

    expect(result.statusCode).toBe(200);

    expect(result.client[0]).toMatchObject({
      klijent: expectedClientInfo.klijent,
      datum_rodjenja: expectedClientInfo.datum_rodjenja,
      'embg/pib': expectedClientInfo['embg/pib'],
      adresa: expectedClientInfo.adresa,
      mjesto: expectedClientInfo.mjesto,
      telefon1: expectedClientInfo.telefon1,
      telefon2: expectedClientInfo.telefon2,
      email: expectedClientInfo.email,
      polisa: expectedClientInfo.polisa,
      pocetak_osiguranja: expectedClientInfo.pocetak_osiguranja,
      istek_osiguranja: expectedClientInfo.istek_osiguranja,
      datum_storna: expectedClientInfo.datum_storna,
      nacin_placanja: expectedClientInfo.nacin_placanja,
      nacin_placanja_sifra: expectedClientInfo.nacin_placanja_sifra,
      naziv_branse: expectedClientInfo.naziv_branse,
      bruto_polisirana_premija: expectedClientInfo.bruto_polisirana_premija,
      neto_polisirana_premija: expectedClientInfo.neto_polisirana_premija,
      dani_kasnjenja: expectedClientInfo.dani_kasnjenja,
      ukupna_potrazivanja: expectedClientInfo.ukupna_potrazivanja,
      status_polise: expectedClientInfo.status_polise,
      bransa: expectedClientInfo.bransa,
      storno_tip: expectedClientInfo.storno_tip,
      uplacena_premija: expectedClientInfo.uplacena_premija,
      broj_ponude: expectedClientInfo.broj_ponude,
      pko_buch_nr: expectedClientInfo.pko_buch_nr,
      datum_dokumenta: expectedClientInfo.datum_dokumenta,
      duguje: expectedClientInfo.duguje,
      potrazuje: expectedClientInfo.potrazuje,
      saldo: expectedClientInfo.saldo,
      klijent_bruto_polisirana_premija: expectedClientInfo.klijent_bruto_polisirana_premija,
      klijent_neto_polisirana_premija: expectedClientInfo.klijent_neto_polisirana_premija,
      dospjela_potrazivanja: expectedClientInfo.dospjela_potrazivanja,
      trangrupa1: expectedClientInfo.trangrupa1,
      trangrupa2: expectedClientInfo.trangrupa2,
      klijent_dospjela_potrazivanja: expectedClientInfo.klijent_dospjela_potrazivanja,
    });

    expect(result.client.length).toBe(92);
  });

  it('should return empty all client info', async () => {
    const result = await ClientQueries.getAllClientInfo('000', '2024.01.01', '2024.07.31');
    expect(result.client).toEqual([]);
  });

  it('should return corrent client policy info', async () => {
    const expectedClientPolicyInfo = {
      broj_polise: 98026687,
      broj_ponude: 0,
      pol_kreis: 99,
      bransa: 11,
      naziv_branse: 'KASKO OSIGURANJE MOTORNIH VOZILA',
      pocetak_osiguranja: '24.07.2024',
      istek_osiguranja: '24.07.2025',
      datum_storna: '24.07.2025',
      storno_tip: 67,
      status_polise: 'Aktivna',
      nacin_placanja_sifra: 1,
      nacin_placanja: 'godišnje placanje',
      bruto_polisirana_premija: 132.52,
      neto_polisirana_premija: 121.58,
      sifra_zastupnika: 35036,
      naziv_zastupnika: ' ',
      kanal_prodaje: null,
      dani_kasnjenja: 6,
      ugovarac: 'RADIO I TELEVIZIJA CRNE GORE ',
      osiguranik: 'RADIO I TELEVIZIJA CRNE GORE ',
    };

    const result = await ClientQueries.getClientPolicyAnalticalInfo('98026687', '2024.01.01', '2024.07.31');

    expect(result.statusCode).toBe(200);

    expect(result.client).toMatchObject({
      broj_polise: expectedClientPolicyInfo.broj_polise,
      broj_ponude: expectedClientPolicyInfo.broj_ponude,
      pol_kreis: expectedClientPolicyInfo.pol_kreis,
      bransa: expectedClientPolicyInfo.bransa,
      naziv_branse: expectedClientPolicyInfo.naziv_branse,
      pocetak_osiguranja: expectedClientPolicyInfo.pocetak_osiguranja,
      istek_osiguranja: expectedClientPolicyInfo.istek_osiguranja,
      datum_storna: expectedClientPolicyInfo.datum_storna,
      storno_tip: expectedClientPolicyInfo.storno_tip,
      status_polise: expectedClientPolicyInfo.status_polise,
      nacin_placanja_sifra: expectedClientPolicyInfo.nacin_placanja_sifra,
      nacin_placanja: expectedClientPolicyInfo.nacin_placanja,
      bruto_polisirana_premija: expectedClientPolicyInfo.bruto_polisirana_premija,
      neto_polisirana_premija: expectedClientPolicyInfo.neto_polisirana_premija,
      sifra_zastupnika: expectedClientPolicyInfo.sifra_zastupnika,
      naziv_zastupnika: expectedClientPolicyInfo.naziv_zastupnika,
      kanal_prodaje: expectedClientPolicyInfo.kanal_prodaje,
      dani_kasnjenja: expectedClientPolicyInfo.dani_kasnjenja,
      ugovarac: expectedClientPolicyInfo.ugovarac,
      osiguranik: expectedClientPolicyInfo.osiguranik,
    });
  });

  it('should return empty client policy info', async () => {
    const result = await ClientQueries.getClientPolicyAnalticalInfo('00000000', '2024.01.01', '2024.07.31');
    expect(result.statusCode).toBe(200);
    expect(result.client).toEqual({});
  });

  it('should return financial history of a client', async () => {
    const result = await ClientQueries.getClientFinancialHistory('02020220', '2024.01.02', '2026.01.02', 1, 1);
    const expectedClientFinancialHistory = {
      row_num: '85',
      datum_dokumenta: '31.08.2024',
      broj_dokumenta: 9003538,
      broj_ponude: 0,
      zaduzeno: 0,
      uplaceno: 1087.44,
      saldo: 25306.69,
      datum_od: '01.01.2024',
      datum_do: '01.01.2026',
    };

    expect(result.statusCode).toBe(200);

    expect(result.clientFinHistory[result.clientFinHistory.length - 1]).toMatchObject({
      datum_dokumenta: expectedClientFinancialHistory.datum_dokumenta,
      broj_dokumenta: expectedClientFinancialHistory.broj_dokumenta,
      broj_ponude: expectedClientFinancialHistory.broj_ponude,
      zaduzeno: expectedClientFinancialHistory.zaduzeno,
      uplaceno: expectedClientFinancialHistory.uplaceno,
      saldo: expectedClientFinancialHistory.saldo,
      datum_od: expectedClientFinancialHistory.datum_od,
      datum_do: expectedClientFinancialHistory.datum_do,
    });
  });

  it('should return empty financial history of a client', async () => {
    const result = await ClientQueries.getClientFinancialHistory('00000000', '2024.01.01', '2024.07.31');
    expect(result.statusCode).toBe(200);
    expect(result.clientFinHistory).toEqual([]);
  });

  it('should return exact financial info of a client', async () => {
    const result = await ClientQueries.getClientFinancialInfo('02020220', '2024.01.01', '2026.01.01');
    const expectedClientFinancialInfo = {
      ukupno_nedospjelo: 25306.69,
      ukupno_dospjelo: 0,
    };

    expect(result.statusCode).toBe(200);

    expect(result.clientFinInfo).toMatchObject({
      ukupno_nedospjelo: expectedClientFinancialInfo.ukupno_nedospjelo,
      ukupno_dospjelo: expectedClientFinancialInfo.ukupno_dospjelo,
    });
  });

  it('should return empty financial info of a client', async () => {
    const result = await ClientQueries.getClientFinancialInfo('00000000', '2024.01.01', '2024.07.31');
    expect(result.statusCode).toBe(200);
    expect(result.clientFinInfo).toEqual({});
  });

  it('should return an error if uncorrect date format is provided', async () => {
    await expect(ClientQueries.getClientHistory('02020220', '2024.31.31', '2024.31.31')).rejects.toThrow();
  });

  it('should close the connection', async () => {
    const originalClose = connection.close;
    connection.close = jest.fn().mockImplementation(async () => {
      await originalClose.call(connection);
    });

    await connection.close();
    expect(connection.close).toHaveBeenCalled();

    connection.close = originalClose;
  });
});
