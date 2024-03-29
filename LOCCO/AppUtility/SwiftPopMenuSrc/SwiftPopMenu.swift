
import UIKit

protocol SwiftPopMenuDelegate :NSObjectProtocol{
    func swiftPopMenuDidSelectIndex(index:Int)
}
public enum SwiftPopMenuConfigure {
    case PopMenuTextFont(UIFont)
    case PopMenuTextColor(UIColor)
    case PopMenuBackgroudColor(UIColor)
    case popMenuCornorRadius(CGFloat)
    case popMenuItemHeight(CGFloat)
    case popMenuSplitLineColor(UIColor)
    case popMenuIconLeftMargin(CGFloat)          //icon
    case popMenuMargin(CGFloat)
    case popMenuAlpha(CGFloat)
}
public class SwiftPopMenu: UIView {
    //delegate
    weak var delegate : SwiftPopMenuDelegate?
    //block
    public var didSelectMenuBlock:((_ index:Int)->Void)?
    
    let KScrW:CGFloat = UIScreen.main.bounds.size.width
    let KScrH:CGFloat = UIScreen.main.bounds.size.height
    ///* ----------------------- External parameters are set through configure ------------------ ---------- *／
    //Background transparency outside the area
    private var popMenuOutAlpha:CGFloat = 0
    //background color
    private var popMenuBgColor:UIColor = UIColor.white
    //MenuCornorRadius
    private var popMenuCornorRadius:CGFloat = 6
    //MenuTextColor
    private var popMenuTextColor:UIColor = UIColor.black
    //MenuTextFont
    private var popMenuTextFont:UIFont = UIFont.systemFont(ofSize: 17)
    //MenuItemHeight
    private var popMenuItemHeight:CGFloat = 44.0
    //MenuSplitLineColor
    private var popMenuSplitLineColor:UIColor = UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 0.5)
    //MenuIconLeftMargin
    private var popMenuIconLeftMargin:CGFloat = 15
    //MenuMargin
    private var popMenuMargin:CGFloat = 10
    
    ///* ---------------------------- External parameters over-------------------------- ----------------------- *／
    // Shadow properties
    private var PopMenuShadowColor: UIColor = UIColor.black
    private var PopMenuShadowOpacity: Float = 0.2
    private var PopMenuShadowOffset: CGSize = CGSize(width: 0, height: 2)
    private var PopMenuShadowRadius: CGFloat = 13.5
    
    private var arrowPoint : CGPoint = CGPoint.zero         //small arrow position
    private var arrowViewWidth : CGFloat = 23               //triangular arrow width
    private var arrowViewHeight : CGFloat = 14               //triangular arrow height
    private var popData:[(icon:String,title:String)]!       //data source
    
    static let cellID:String = "SwiftPopMenuCellID"
    private var myFrame:CGRect!     //tableview  frame
    private var arrowView : UIView! = nil
    
    var tableView:UITableView! = nil
    /// Initialization menu
    ///
    /// - Parameters:
    /// - menuWidth: menu width
    /// - arrow: The arrow position is the position of the popmenu relative to the entire screen
    /// - datas: data source. The icon is allowed to be empty. If the data source has no data, the menu will not be displayed.
    /// - configure: configuration information, can not be passed
    init(menuWidth:CGFloat,arrow:CGPoint,datas:[(icon:String,title:String)],configures:[SwiftPopMenuConfigure] = []) {
        super.init(frame: UIScreen.main.bounds)
        self.frame = UIScreen.main.bounds
        //Read configuration
        configures.forEach { (config) in
            switch (config){
            case let .PopMenuTextFont(value):
                popMenuTextFont = value
            case let .PopMenuTextColor(value):
                popMenuTextColor = value
            case let .PopMenuBackgroudColor(value):
                popMenuBgColor = value
            case let .popMenuCornorRadius(value):
                popMenuCornorRadius = value
            case let .popMenuItemHeight(value):
                popMenuItemHeight = value
            case let .popMenuSplitLineColor(value):
                popMenuSplitLineColor = value
            case let .popMenuIconLeftMargin(value):
                popMenuIconLeftMargin = value
            case let .popMenuMargin(value):
                popMenuMargin = value
            case let .popMenuAlpha(value):
                popMenuOutAlpha = value
            }
        }
        popData = datas
        //Set myFrame size, original will be calculated later
        myFrame = CGRect(x: 0, y: 0, width: menuWidth, height: popMenuItemHeight*CGFloat(popData.count))
        myFrame.size.height = min(KScrH/2, myFrame.height)
        myFrame.size.width = min(KScrW-popMenuMargin*2, myFrame.width)
        //Set the shoulder to 10 from the screen
        arrowPoint = arrow
        arrowPoint.x = max(popMenuMargin, min(arrowPoint.x, KScrW-popMenuMargin))
        
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initViews() {
        self.backgroundColor = UIColor.black.withAlphaComponent(popMenuOutAlpha)
        let arrowPs = getArrowPoints()
        myFrame.origin = arrowPs.3
        let isarrowUP = arrowPs.4
        print(arrowPs)
        self.layer.shadowColor = UIColor.popBlur.cgColor
        self.layer.shadowOpacity = PopMenuShadowOpacity
        self.layer.shadowOffset = PopMenuShadowOffset
        self.layer.shadowRadius = PopMenuShadowRadius
        //arrow
        arrowView=UIView(frame: CGRect(x: myFrame.origin.x, y: isarrowUP ? myFrame.origin.y-arrowViewHeight : myFrame.origin.y+myFrame.height, width: myFrame.width, height: arrowViewHeight))
        let layer=CAShapeLayer()
        let path=UIBezierPath()
        path.move(to: arrowPs.0)
        path.addLine(to: arrowPs.1)
        path.addLine(to: arrowPs.2)
        layer.path=path.cgPath
        layer.fillColor = popMenuBgColor.cgColor
        arrowView.layer.addSublayer(layer)
        self.addSubview(arrowView)
        tableView=UITableView(frame: CGRect(x: myFrame.origin.x,y: myFrame.origin.y,width: myFrame.width,height: myFrame.height), style: .plain)
        tableView.register(SwiftPopMenuCell.classForCoder(), forCellReuseIdentifier: SwiftPopMenu.cellID)
        tableView.backgroundColor = popMenuBgColor
        tableView.layer.cornerRadius = popMenuCornorRadius
        tableView.separatorStyle = .none
        tableView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        UIView.animate(withDuration: 0.3) {
            self.addSubview(self.tableView)
        }
    }
    /// Calculate arrow position
    ///
    /// - Returns: (triangular arrow top, triangular arrow left, triangular arrow right, tableview origin, whether the arrow is pointing up)
    func getArrowPoints() -> (CGPoint,CGPoint,CGPoint,CGPoint,Bool) {
        if arrowPoint.x <= popMenuMargin {
            arrowPoint.x = popMenuMargin
        }
        if arrowPoint.x >= KScrW - popMenuMargin{
            arrowPoint.x = KScrW - popMenuMargin
        }
        var originalPoint = CGPoint.zero
        //Arrow middle distance left distance
        var arrowMargin:CGFloat = popMenuMargin
        if arrowPoint.x < KScrW/2{
            if (arrowPoint.x > myFrame.width/2) {
                arrowMargin = myFrame.width/2
                originalPoint = CGPoint(x: arrowPoint.x - myFrame.width/2, y: arrowPoint.y+arrowViewHeight)
            }else{
                arrowMargin = arrowPoint.x-popMenuMargin
                originalPoint = CGPoint(x: popMenuMargin, y: arrowPoint.y+arrowViewHeight)
            }
        }else{
            if (KScrW-arrowPoint.x) < myFrame.width/2{
                arrowMargin = (myFrame.width - KScrW + arrowPoint.x )
                originalPoint = CGPoint(x: KScrW-popMenuMargin-myFrame.width, y: arrowPoint.y+arrowViewHeight)
            }else{
                arrowMargin = myFrame.width/2
                originalPoint = CGPoint(x: arrowPoint.x-myFrame.width/2, y: arrowPoint.y+arrowViewHeight)
            }
        }
        //arrow pointing up
        if (KScrH - arrowPoint.y) > myFrame.height{
            return (CGPoint(x: arrowMargin, y: 0),CGPoint(x: arrowMargin-arrowViewWidth/2, y: arrowViewHeight),CGPoint(x: arrowMargin+arrowViewWidth/2, y: arrowViewHeight),originalPoint,true)
        }else{
            originalPoint.y = arrowPoint.y-myFrame.height-arrowViewHeight
            return (CGPoint(x: arrowMargin, y: arrowViewHeight),CGPoint(x: arrowMargin-arrowViewWidth/2, y: 0),CGPoint(x: arrowMargin+arrowViewWidth/2, y: 0),originalPoint,false)
        }
    }
}
// MARK: - Show and hide pages
extension SwiftPopMenu{
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != tableView{
            dismiss()
        }
    }
    public func show() {
        if popData.isEmpty{
            return
        }
        initViews()
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    public func dismiss() {
        self.removeFromSuperview()
    }
}
// MARK: - UITableViewDataSource,UITableViewDelegate
extension SwiftPopMenu : UITableViewDataSource,UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popData.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if popData.count>indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: SwiftPopMenu.cellID) as! SwiftPopMenuCell
            let model = popData[indexPath.row]
            cell.setConfig(_txtColor: popMenuTextColor, _lineColor: popMenuSplitLineColor, _txtFont: popMenuTextFont, _iconLeft: popMenuIconLeftMargin)
            if indexPath.row == popData.count - 1 {
                cell.fill(iconName: model.icon, title: model.title, isLast: true)
            }else{
                cell.fill(iconName: model.icon, title: model.title)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return popMenuItemHeight
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil{
            self.delegate?.swiftPopMenuDidSelectIndex(index: indexPath.row)
        }
        if didSelectMenuBlock != nil {
            didSelectMenuBlock!(indexPath.row)
        }
        dismiss()
    }
    
}

/// UITableViewCell
class SwiftPopMenuCell: UITableViewCell {
    var iconImage:UIImageView!
    var lblTitle:UILabel!
    var line:UIView!
    //Custom properties
    var lineColor:UIColor = UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 0.5)
    var txtColor:UIColor = UIColor.black
    var txtFont:UIFont = UIFont.systemFont(ofSize: 17)
    var iconLeft:CGFloat = 15
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        iconImage = UIImageView()
        self.contentView.addSubview(iconImage)
        self.selectionStyle = .none
        
        lblTitle = UILabel()
        self.contentView.addSubview(lblTitle)
        
        line = UIView()
        self.contentView.addSubview(line)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func fill(iconName: String, title: String, isLast: Bool = false) {
        iconImage.image = UIImage(named: iconName)
        lblTitle.text = title
        line.isHidden = isLast
        // Set text color based on the title
        if title == "reminder_page-delete".translated {
            lblTitle.textColor = UIColor.appRed
            // Set red color for "Delete" title
            lblTitle.font = AppFont.medium(size: 15)
        } else {
            lblTitle.textColor = txtColor // Set default text color
        }
    }
    func setConfig(_txtColor: UIColor, _lineColor: UIColor, _txtFont: UIFont, _iconLeft: CGFloat) {
        txtFont = _txtFont
        lineColor = _lineColor
        iconLeft = _iconLeft
        line.backgroundColor = lineColor
        lblTitle.font = txtFont
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconImage.frame = CGRect(x: iconLeft, y: (self.bounds.size.height - 20)/2, width: 20, height: 20)
        self.lblTitle.frame = CGRect(x: 20+iconLeft*2, y: 0, width: self.bounds.size.width - 40, height: self.bounds.size.height)
        // Calculate the x position to center the line horizontally
        let xPosition = (self.bounds.size.width - 149) / 2
        // Set the line's frame with the calculated x position
        self.line.frame = CGRect(x: xPosition, y: self.bounds.size.height - 1, width: 149, height: 1)
    }
}
