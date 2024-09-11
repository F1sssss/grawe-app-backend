const request = require('supertest');
const express = require('express');
const policyController = require('../../controllers/policyController');
const policyService = require('../../services/policyService');

jest.mock('../../services/policyService');

const app = express();
app.get('/api/policies/:id', policyController.getPolicyInfo);
app.get('/api/policies/:id/analytics', policyController.getPolicyAnalyticalInfo);
app.get('/api/policies/:id/history', policyController.getPolicyHistory);
app.get('/api/policies/:id/history/xls/download', policyController.getPolicyHistoryExcelDownload);
app.get('/api/policies/:id/history/pdf/download', policyController.getPolicyHistoryPDFDownload);

describe('Policy Controller', () => {
  it('should return policy info with status code 200', async () => {
    const mockPolicyData = { policy: { id: '123', name: 'Test Policy' }, statusCode: 200 };
    policyService.getPolicyInfoService.mockResolvedValue(mockPolicyData);

    const response = await request(app).get('/api/policies/123');

    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual(mockPolicyData);
  });

  it('should return policy analytical info with status code 200', async () => {
    const mockPolicyData = { policy: { id: '123', name: 'Analytical Info' }, statusCode: 200 };
    policyService.getPolicyAnalyticalInfoService.mockResolvedValue(mockPolicyData);

    const response = await request(app).get('/api/policies/123/analytics?dateFrom=2023-01-01&dateTo=2023-01-31');

    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual(mockPolicyData);
  });

  it('should return policy history with status code 200', async () => {
    const mockPolicyData = { policy: { id: '123', history: 'Policy History' }, statusCode: 200 };
    policyService.getPolicyHistoryService.mockResolvedValue(mockPolicyData);

    const response = await request(app).get('/api/policies/123/history?dateFrom=2023-01-01&dateTo=2023-01-31');

    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual(mockPolicyData);
  });

  it('should return policy history excel download', async () => {
    const mockExcelBuffer = Buffer.from('Excel file content');
    policyService.getPolicyHistoryExcelDownloadService.mockResolvedValue({ excelBuffer: mockExcelBuffer });

    const response = await request(app).get('/api/policies/123/history/xls/download?dateFrom=2023-01-01&dateTo=2023-01-31');

    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual(mockExcelBuffer);
  });

  it('should return policy history pdf download', async () => {
    const mockPdfBuffer = Buffer.from('PDF file content');
    policyService.getPolicyHistoryPDFDownloadService.mockResolvedValue({ pdfBuffer: mockPdfBuffer, statusCode: 200 });

    const response = await request(app).get('/api/policies/123/history/pdf/download?dateFrom=2023-01-01&dateTo=2023-01-31');

    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual(mockPdfBuffer);
  });
});
