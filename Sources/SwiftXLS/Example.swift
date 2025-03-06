import Foundation

public extension XLSWorkbook {
    /// 将工作簿转换为文本格式
    /// - Returns: 包含所有工作表内容的文本
    func convertToText() throws -> String {
        var result = ""
        
        for sheetIndex in 0..<sheetsCount {
            let worksheet = try sheet(at: sheetIndex)
            
            // 添加工作表名称
            if let sheetName = worksheet.name {
                result += "=== \(sheetName) ===\n"
            } else {
                result += "=== Sheet\(sheetIndex + 1) ===\n"
            }
            
            // 读取所有单元格
            for row in 0..<worksheet.rowsCount {
                var rowText = ""
                for col in 0..<worksheet.columnsCount {
                    if let cell = try worksheet.cell(row: row, col: col) {
                        let cellText: String
                        switch cell.type {
                        case .string:
                            cellText = cell.stringValue ?? ""
                        case .number:
                            cellText = cell.numberValue?.description ?? ""
                        case .boolean:
                            cellText = cell.booleanValue == true ? "是" : "否"
                        case .date:
                            cellText = cell.dateValue?.description ?? ""
                        case .blank:
                            cellText = ""
                        case .error:
                            cellText = "#ERROR#"
                        }
                        rowText += cellText
                    }
                    rowText += "\t"
                }
                result += rowText.trimmingCharacters(in: .whitespaces)
                result += "\n"
            }
            result += "\n"
        }
        
        return result
    }
}

// 使用示例：
/*
do {
    let url = URL(fileURLWithPath: "path/to/your.xls")
    let workbook = try XLSWorkbook(url: url)
    
    // 获取工作表数量
    print("工作表数量：\(workbook.sheetsCount)")
    
    // 读取所有工作表
    for i in 0..<workbook.sheetsCount {
        let worksheet = try workbook.sheet(at: i)
        print("工作表名称：\(worksheet.name ?? "未命名")")
        print("行数：\(worksheet.rowsCount)")
        print("列数：\(worksheet.columnsCount)")
        
        // 读取单元格 A1
        if let cell = try worksheet.cell(row: 0, col: 0) {
            switch cell.type {
            case .string:
                print("A1 的文本值：\(cell.stringValue ?? "")")
            case .number:
                print("A1 的数值：\(cell.numberValue ?? 0)")
            case .boolean:
                print("A1 的布尔值：\(cell.booleanValue == true ? "是" : "否")")
            default:
                print("A1 是其他类型")
            }
        }
    }
    
    // 转换为文本
    let text = try workbook.convertToText()
    print(text)
    
} catch {
    print("错误：\(error)")
}
*/ 