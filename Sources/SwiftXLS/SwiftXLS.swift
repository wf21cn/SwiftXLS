import Foundation
import Clibxls

public enum XLSError: Error {
    case openFailed(String)
    case sheetNotFound
    case invalidWorkbook
    case readError(String)
}

public struct XLSCell {
    public let stringValue: String?
    public let numberValue: Double?
    public let booleanValue: Bool?
    public let dateValue: Date?
    public let type: CellType
    
    public enum CellType {
        case string
        case number
        case boolean
        case date
        case blank
        case error
    }
}

public class XLSWorkbook {
    private var workbook: UnsafeMutablePointer<xlsWorkBook>?
    
    public init(url: URL) throws {
        guard let cPath = url.path.cString(using: .utf8) else {
            throw XLSError.openFailed("无效的文件路径")
        }
        
        workbook = xls_open(cPath, "UTF-8")
        guard workbook != nil else {
            throw XLSError.openFailed("无法打开 XLS 文件")
        }
    }
    
    deinit {
        if let wb = workbook {
            xls_close_WB(wb)
        }
    }
    
    public var sheetsCount: Int {
        guard let wb = workbook else { return 0 }
        return Int(wb.pointee.sheets.count)
    }
    
    public func sheet(at index: Int) throws -> XLSWorksheet {
        guard let wb = workbook else {
            throw XLSError.invalidWorkbook
        }
        
        guard index >= 0 && index < sheetsCount else {
            throw XLSError.sheetNotFound
        }
        
        guard let sheet = xls_getWorkSheet(wb, Int32(index)) else {
            throw XLSError.sheetNotFound
        }
        
        let status = xls_parseWorkSheet(sheet)
        guard status.rawValue == 0 else {
            throw XLSError.readError("解析工作表失败")
        }
        
        return XLSWorksheet(worksheet: sheet)
    }
}

public class XLSWorksheet {
    private var worksheet: UnsafeMutablePointer<xlsWorkSheet>
    
    init(worksheet: UnsafeMutablePointer<xlsWorkSheet>) {
        self.worksheet = worksheet
    }
    
    deinit {
        xls_close_WS(worksheet)
    }
    
    public var name: String? {
        guard let namePtr = worksheet.pointee.workbook.pointee.sheets.sheet[Int(worksheet.pointee.workbook.pointee.activeSheetIdx)].name else {
            return nil
        }
        return String(cString: namePtr)
    }
    
    public var rowsCount: Int {
        return Int(worksheet.pointee.rows.lastrow) + 1
    }
    
    public var columnsCount: Int {
        return Int(worksheet.pointee.rows.lastcol) + 1
    }
    
    public func cell(row: Int, col: Int) throws -> XLSCell? {
        guard row >= 0 && row < rowsCount && col >= 0 && col < columnsCount else {
            return nil
        }
        
        guard let xlsRow = xls_row(worksheet, UInt16(row)) else {
            return nil
        }
        
        let cell = xlsRow.pointee.cells.cell[col]
        
        let type: XLSCell.CellType
        var stringValue: String?
        var numberValue: Double?
        var booleanValue: Bool?
        var dateValue: Date?
        
        let cellId = cell.id
        switch cellId {
        case 0x0201:  // BLANK
            type = .blank
            
        case 0x0203:  // NUMBER
            type = .number
            numberValue = cell.d
            
        case 0x0205:  // BOOLERR
            type = .boolean
            booleanValue = cell.d > 0
            
        case 0x0204, 0x0207, 0x00FC:  // LABEL, STRING, SST
            type = .string
            if let str = cell.str {
                stringValue = String(cString: str)
            }
            
        default:
            if let str = cell.str {
                type = .string
                stringValue = String(cString: str)
            } else {
                type = .blank
            }
        }
        
        return XLSCell(
            stringValue: stringValue,
            numberValue: numberValue,
            booleanValue: booleanValue,
            dateValue: dateValue,
            type: type
        )
    }
}
