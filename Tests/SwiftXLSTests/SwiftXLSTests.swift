import XCTest
@testable import SwiftXLS

final class SwiftXLSTests: XCTestCase {
    func testReadXLSFile() throws {
        // 创建测试文件路径
        let downloadPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Downloads/test.xls")
        print("测试文件路径：", downloadPath.path)
        
        // 打开工作簿
        let workbook = try XLSWorkbook(url: downloadPath)
        XCTAssertGreaterThan(workbook.sheetsCount, 0, "工作簿应该至少包含一个工作表")
        
        // 读取第一个工作表
        let worksheet = try workbook.sheet(at: 0)
        XCTAssertNotNil(worksheet.name, "工作表应该有名称")
        
        // 验证行列数
        XCTAssertGreaterThan(worksheet.rowsCount, 0, "工作表应该至少包含一行")
        XCTAssertGreaterThan(worksheet.columnsCount, 0, "工作表应该至少包含一列")
        
        // 读取单元格
        if let cell = try worksheet.cell(row: 0, col: 0) {
            XCTAssertNotNil(cell.stringValue ?? cell.numberValue ?? cell.booleanValue, "单元格应该包含值")
        }
    }
    
    func testInvalidFile() {
        // 测试不存在的文件
        let invalidURL = URL(fileURLWithPath: "/path/to/nonexistent.xls")
        XCTAssertThrowsError(try XLSWorkbook(url: invalidURL)) { error in
            guard case XLSError.openFailed = error else {
                XCTFail("应该抛出 openFailed 错误")
                return
            }
        }
    }
    
    func testOutOfBounds() throws {
        // 创建测试文件路径
        let downloadPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Downloads/test.xls")
        
        // 打开工作簿
        let workbook = try XLSWorkbook(url: downloadPath)
        let worksheet = try workbook.sheet(at: 0)
        
        // 测试越界访问
        XCTAssertNil(try worksheet.cell(row: -1, col: 0), "负数行索引应该返回 nil")
        XCTAssertNil(try worksheet.cell(row: 0, col: -1), "负数列索引应该返回 nil")
        XCTAssertNil(try worksheet.cell(row: worksheet.rowsCount, col: 0), "超出行数应该返回 nil")
        XCTAssertNil(try worksheet.cell(row: 0, col: worksheet.columnsCount), "超出列数应该返回 nil")
    }
}
