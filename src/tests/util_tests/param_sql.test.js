const loadSqlQueries = require('../../sql/sql_queries/loadSQLQueries');
const fse = require('fs-extra');
const path = require('path');

jest.mock('fs-extra');
jest.mock('path', () => ({
  ...jest.requireActual('path'),
  join: jest.fn(),
}));

describe('loadSqlQueries', () => {
  const mockQueriesDir = '/mock/path/src/sql/sql_queries';

  beforeEach(() => {
    jest.clearAllMocks();
    process.cwd = jest.fn().mockReturnValue('/mock/path');
    path.join.mockImplementation((...args) => args.join('/'));
  });

  it('should load a single SQL file when QueryFileName is provided', async () => {
    const mockQueryFileName = 'testQuery.sql';
    const mockQueryContent = 'SELECT * FROM test';

    fse.readFileSync.mockReturnValue(mockQueryContent);

    const result = await loadSqlQueries(mockQueryFileName);

    expect(path.join).toHaveBeenCalledWith(mockQueriesDir, mockQueryFileName);
    expect(fse.readFileSync).toHaveBeenCalledWith(`${mockQueriesDir}/${mockQueryFileName}`, { encoding: 'UTF-8' });
    expect(result).toBe(mockQueryContent);
  });

  it('should load all SQL files when QueryFileName is not provided', async () => {
    const mockFiles = ['query1.sql', 'query2.sql', 'notSQL.txt'];
    const mockQueryContents = {
      'query1.sql': 'SELECT * FROM table1',
      'query2.sql': 'SELECT * FROM table2',
    };

    fse.readdir.mockResolvedValue(mockFiles);
    fse.readFileSync.mockImplementation((filePath) => {
      const fileName = path.basename(filePath);
      return mockQueryContents[fileName] || '';
    });

    const result = await loadSqlQueries();

    expect(fse.readdir).toHaveBeenCalledWith(mockQueriesDir);
    expect(fse.readFileSync).toHaveBeenCalledTimes(2);
    expect(fse.readFileSync).toHaveBeenCalledWith(`${mockQueriesDir}/query1.sql`, { encoding: 'UTF-8' });
    expect(fse.readFileSync).toHaveBeenCalledWith(`${mockQueriesDir}/query2.sql`, { encoding: 'UTF-8' });
    expect(result).toEqual({
      query1: 'SELECT * FROM table1',
      query2: 'SELECT * FROM table2',
    });
  });

  it('should return an empty object when no SQL files are found', async () => {
    fse.readdir.mockResolvedValue(['notSQL.txt']);

    const result = await loadSqlQueries();

    expect(fse.readdir).toHaveBeenCalledWith(mockQueriesDir);
    expect(fse.readFileSync).not.toHaveBeenCalled();
    expect(result).toEqual({});
  });

  it('should handle errors when reading directory', async () => {
    const mockError = new Error('Failed to read directory');
    fse.readdir.mockRejectedValue(mockError);

    await expect(loadSqlQueries()).rejects.toThrow('Failed to read directory');
  });

  it('should handle errors when reading file', async () => {
    fse.readdir.mockResolvedValue(['query.sql']);
    const mockError = new Error('Failed to read file');
    fse.readFileSync.mockImplementation(() => {
      throw mockError;
    });

    await expect(loadSqlQueries()).rejects.toThrow('Failed to read file');
  });
});
