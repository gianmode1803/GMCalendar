//
//  CalendarViewPod.swift
//  CalendarView
//
//  Created by Gianpiero Mode on 20/02/2020.
//  Copyright © 2020 Gianpiero Mode. All rights reserved.
//

import UIKit

public protocol GMCalendarDelegate{
    func didSelectedDay(view: UIView, day: Int, isAvailable: Bool)
    func didUpdateMonth(view: UIView, month: Int, year: Int)
}


public class GMCalendar: UIView {

    //MARK: - IBOutlets
    @IBOutlet weak private var content: UIView!
    
    //MARK: - Modifiable properties
    @IBInspectable public var monthNameVisible: Bool = true
    @IBInspectable public var borderColor: UIColor = .clear
    @IBInspectable public var borderWidth: CGFloat = 0
    @IBInspectable public var cornerRadius: CGFloat = 0
    @IBInspectable public var task1Color: UIColor = .blue
    @IBInspectable public var task2Color: UIColor = .red
    
    @IBInspectable public var arrowsAvailable: Bool = true
    @IBInspectable public var rightArrowImage: UIImage? = UIImage(named: "right_arrow")
    @IBInspectable public var leftArrowImage: UIImage? = UIImage(named: "left_arrow")
    
    @IBInspectable public var verticalSwipe: Bool = true
    @IBInspectable public var horizontalSwipe: Bool = true
    
    @IBInspectable public var animation: Bool = true
    @IBInspectable public var animationDuration: TimeInterval = 0.5
    
    @IBInspectable public var colorForDaySelected: UIColor = .red
    
    @IBInspectable public var widthForView: CGFloat = 275//360//260
    @IBInspectable public var heightForView: CGFloat = 275//360//300
    
    //AnimationType
    public var animationForMonthUpdate: AnimationType = .other
    
    public var notAvailableDays: [DayModel] = [
        DayModel(day: 1, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
        DayModel(day: 2, month: 3, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
        DayModel(day: 3, month: 3, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2")]
    
    public var daysWithTasks: [DayModel] = [
        DayModel(day: 1, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
        DayModel(day: 5, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
        DayModel(day: 7, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
        DayModel(day: 12, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
        DayModel(day: 13, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
        DayModel(day: 20, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
        DayModel(day: 23, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: false, task2Description: "Prueba 2")]
    
    //MARK: - Not modifiable properties
    //1 sunday, 2 monday
    private let firstDay = Calendar.current.firstWeekday
    
    private var originalMonth: Int = 2
    private var originalYear: Int = 2020
    private var currentMonth: Int = 2
    private var currentYear: Int = 2020
    private var numberOfDaysInMonth: Int = 30
    private var currentDate: Date = Date()
    private var viewForDaySelected: UIView?
    private var weeksInMonth: Int = 0
    
    private var spaceBetweenMarginAndHeader: CGFloat = 10
    private var monthHeader: CGFloat = 25
    private var spaceBetweenMonthAndHeader: CGFloat = 20
    private var spaceBetweenDays: CGFloat = 5
    private var headerHeight: CGFloat = 25
    private var spaceBetweenHeaderAndDays: CGFloat = 25
    private var verticalSpaceBetweenDays: CGFloat = 20
    private var dayHeight: CGFloat = 25
    
    private let cal = Calendar(identifier: .gregorian)
    private var dayNames: [String] = []
    
    public var delegate: GMCalendarDelegate?
    
    //MARK: - Life cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override public func awakeFromNib() {
        //self.initView()
    }
    
    //MARK: - Custom functions
    
    func commonInit(){

        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.widthForView, height: self.widthForView))
        view.widthAnchor.constraint(equalToConstant: self.widthForView).isActive = true
        view.heightAnchor.constraint(equalToConstant: self.heightForView).isActive = true
        
        let contentview = UIView(frame: CGRect(x: CGFloat(5), y: CGFloat(5), width: (self.widthForView - 10), height: (self.widthForView - 10)))
        contentview.widthAnchor.constraint(equalToConstant: (self.widthForView - 10)).isActive = true
        contentview.heightAnchor.constraint(equalToConstant: self.heightForView - 10).isActive = true
        
        view.addSubview(contentview)
        
        self.content = contentview
        
        self.addSubview(view)
        
        self.initView()
    }
    
    func initView(){
        self.setUpView()
        
        self.originalYear = self.currentYear
        self.originalMonth = self.currentMonth
        self.dayNames = cal.weekdaySymbols
    }
    
    func setupHeights(){

        let viewHeight = self.heightForView
        
        self.monthHeader = viewHeight * 0.05
        self.spaceBetweenMonthAndHeader = viewHeight * 0.05
        self.headerHeight = viewHeight * 0.1
        self.spaceBetweenHeaderAndDays = viewHeight * 0.05
        let heightForDays = ((viewHeight * 0.65)  / CGFloat(self.weeksInMonth))
        
        self.dayHeight = heightForDays * 0.9
        self.verticalSpaceBetweenDays = (heightForDays * 0.1) / CGFloat(self.weeksInMonth)
        
        
    }
    
    func setUpView(){
        self.setUpInitialCalendar()
        self.setupHeights()
        if monthNameVisible{
            addMonthName()
        }else{
            monthHeader = 0
        }
        addHeaders()
        addDays()
        if self.horizontalSwipe{
            addHorizontalSwipe()
        }
        
        if self.verticalSwipe{
            addVerticalSwipe()
        }
        
        self.content.layer.borderColor = self.borderColor.cgColor
        self.content.layer.borderWidth = self.borderWidth
        self.content.layer.cornerRadius = self.cornerRadius
        
    }
    
    private func setUpInitialCalendar(){
        self.currentMonth = cal.component(.month, from: currentDate)
        self.currentYear = cal.component(.year, from: currentDate)
        self.weeksInMonth = cal.range(of: .weekOfMonth, in: .month, for: currentDate)!.count
        if firstDay == 2 {
            self.weeksInMonth = self.weeksInMonth + 1
        }
        self.numberOfDaysInMonth = cal.range(of: .day, in: .month, for: currentDate)!.count
    }
    
    func addHorizontalSwipe(){
        let horizontalLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(horizontalLeftSwipe(_:)))
        horizontalLeftSwipe.direction = .left
        self.addGestureRecognizer(horizontalLeftSwipe)
        
        let horizontalRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(horizontalRightSwipe(_:)))
        horizontalRightSwipe.direction = .right
        self.addGestureRecognizer(horizontalRightSwipe)
    }
    func addVerticalSwipe(){
        let verticalTopSwipe = UISwipeGestureRecognizer(target: self, action: #selector(verticalTopSwipe(_:)))
        verticalTopSwipe.direction = .up
        self.addGestureRecognizer(verticalTopSwipe)
        
        let verticalDownSwipe = UISwipeGestureRecognizer(target: self, action: #selector(verticalDownSwipe(_:)))
        verticalDownSwipe.direction = .down
        self.addGestureRecognizer(verticalDownSwipe)
    }

    func updateViewForNewMonth(){
        self.updateCurrentDate()
        self.cleanContentView()
        self.setUpView()
        self.animateView()
    }
    
    func cleanContentView(){
        for item in self.content.subviews{
            item.removeFromSuperview()
        }
    }
    
    func updateCurrentDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateTime = formatter.date(from: "\(currentYear)/\(currentMonth)/\(01)")
        
        self.currentDate = someDateTime!
    }
    
    func addMonthName(){
        
        let horizontalStackView = UIStackView(frame: CGRect(x: 0, y: spaceBetweenMarginAndHeader, width: self.frame.width - 10, height: self.monthHeader))
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.alignment = .center
        
        let labelName = UILabel(frame: CGRect(x: 0, y: spaceBetweenMarginAndHeader, width: self.frame.width, height: self.monthHeader))
        labelName.text = currentDate.monthAsString().uppercased()
        labelName.textColor = UIColor.black
        labelName.textAlignment = .center
        labelName.font.withSize(25)
        labelName.adjustsFontSizeToFitWidth = true
        labelName.minimumScaleFactor = 0.2
        labelName.numberOfLines = 1
        
        if self.arrowsAvailable{
            //Left Arrow -----
            let leftArrowImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.monthHeader / 2, height: self.monthHeader / 2))
            if self.leftArrowImage != nil{
                leftArrowImageView.image = self.leftArrowImage
                leftArrowImageView.isUserInteractionEnabled = true
                leftArrowImageView.contentMode = .scaleAspectFit
            }
            
            leftArrowImageView.widthAnchor.constraint(equalToConstant: self.headerHeight).isActive = true
            
            let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(leftArrowSelected(_:)))
            leftArrowImageView.addGestureRecognizer(leftTapGesture)
            
            //Left Arrow -----
            let rightArrowImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.monthHeader / 2, height: self.monthHeader / 2))
            if self.rightArrowImage != nil{
                rightArrowImageView.image = self.rightArrowImage
                rightArrowImageView.isUserInteractionEnabled = true
                rightArrowImageView.contentMode = .scaleAspectFit
            }
            
            rightArrowImageView.widthAnchor.constraint(equalToConstant: self.headerHeight).isActive = true
            
            let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(rightArrowSelected(_:)))
            rightArrowImageView.addGestureRecognizer(rightTapGesture)
            
            horizontalStackView.addArrangedSubview(leftArrowImageView)
            horizontalStackView.addArrangedSubview(labelName)
            horizontalStackView.addArrangedSubview(rightArrowImageView)
            
        }else{
            horizontalStackView.addArrangedSubview(labelName)
        }

        self.content.addSubview(horizontalStackView)
    }
    
    func addHeaders(){
        
        let horizontalStack = UIStackView(frame: CGRect(x: 0, y: spaceBetweenMarginAndHeader + monthHeader + spaceBetweenMonthAndHeader, width: self.bounds.width - 10, height: headerHeight))
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fillEqually
        horizontalStack.spacing = spaceBetweenDays
        
        var days = DayItems.allCasesIterable
        if self.firstDay == 1{
            days = [DayItems.sunday, DayItems.monday, DayItems.tuesday, DayItems.wednesday, DayItems.thursday, DayItems.friday, DayItems.saturday]
        }
        
        for item in days{
            let widthForHeader = (self.bounds.width / CGFloat(DayItems.allCasesIterable.count)) - (spaceBetweenDays * CGFloat(DayItems.allCasesIterable.count))
            let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: widthForHeader, height: headerHeight))
            headerLabel.textAlignment = .center
            headerLabel.text = item.getDayName().uppercased()
            headerLabel.adjustsFontSizeToFitWidth = true
            headerLabel.minimumScaleFactor = 0.2
            headerLabel.numberOfLines = 1
            horizontalStack.addArrangedSubview(headerLabel)
        }
        self.content.addSubview(horizontalStack)
        
    }
    
    func addDays(){
        let height = self.frame.height * 0.65//(dayHeight * CGFloat(weeksInMonth)) + (verticalSpaceBetweenDays * CGFloat(weeksInMonth - 1))
        //spaceBetweenMarginAndHeader + monthHeader + 10
        
        let verticalStack = UIStackView(frame: CGRect(x: 0, y: (monthHeader + spaceBetweenMonthAndHeader + spaceBetweenMarginAndHeader + headerHeight + spaceBetweenHeaderAndDays), width: self.bounds.width - 10, height: height))
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = verticalSpaceBetweenDays / 2
        
        var dayCount = 1
        let firstDayOfMonth = getFirstDay(week: WeekNumber.first, month: self.currentMonth, year: self.currentYear)
        let lastDayOfMonth = numberOfDays(month: self.currentMonth, year: self.currentYear)
        
        for i in 1...weeksInMonth {
            
            let horizontalStack = UIStackView(frame: CGRect(x: 0, y: 0, width: self.bounds.width - 10, height: self.dayHeight))
            horizontalStack.axis = .horizontal
            horizontalStack.spacing = spaceBetweenDays
            horizontalStack.distribution = .fillEqually

            for j in 1...7 {

                let widthForButton = (self.bounds.width / CGFloat(DayItems.allCasesIterable.count)) - (spaceBetweenDays * CGFloat(DayItems.allCasesIterable.count))
                let dayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: widthForButton, height: dayHeight))
                horizontalStack.addArrangedSubview(dayLabel)
                //dayLabel.widthAnchor.constraint(equalToConstant: widthForButton).isActive = true
                
                dayLabel.textAlignment = .center
                dayLabel.isUserInteractionEnabled = true
                dayLabel.adjustsFontSizeToFitWidth = true
                dayLabel.minimumScaleFactor = 0.2
                dayLabel.numberOfLines = 1
                
                var dayAdded = false
                if (dayCount > self.numberOfDaysInMonth){
                    dayAdded = false
                    dayCount += 1
                }else if (((i == 1)&&(j >= firstDayOfMonth))||((i != 1) && (i < weeksInMonth))){
                    dayLabel.text = "\(dayCount)"
                    
                    if self.verifyIfDayIsAvailable(day: dayCount, month: self.currentMonth, year: self.currentYear) != nil{
                        dayLabel.textColor = UIColor.lightGray
                    }
                    
                    dayAdded = true
                    dayCount += 1
                }else{
                    if (i == 1){
                        dayLabel.text = ""
                    }else if (dayCount <= lastDayOfMonth){
                        dayLabel.text = "\(dayCount)"
                        
                        if self.verifyIfDayIsAvailable(day: dayCount, month: self.currentMonth, year: self.currentYear) != nil{
                            dayLabel.textColor = UIColor.lightGray
                        }
                        dayAdded = true
                        dayCount += 1
                    }else if((i == weeksInMonth) && (j <= lastDayOfMonth)){
                        dayLabel.text = "\(dayCount)"
                        
                        if self.verifyIfDayIsAvailable(day: dayCount, month: self.currentMonth, year: self.currentYear) != nil{
                            dayLabel.textColor = UIColor.lightGray
                        }
                        dayAdded = true
                        dayCount += 1
                    }else{
                        dayLabel.text = ""
                    }
                }
                if dayAdded{
                    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectedDay(_:)))
                    dayLabel.addGestureRecognizer(gestureRecognizer)
                    let day = Int(dayLabel.text!)
                    if let dayTasks = verifyIfDayHaveTasks(day: day!, month: self.currentMonth, year: self.currentYear) as DayModel?{
                        let yPoint = horizontalStack.frame.height - 6
                        let point = CGPoint(x: dayLabel.frame.width / 2, y: yPoint)
                        var differenceForTask1: CGFloat = 16
                        var differenceForTask2: CGFloat = 11
                        
                        if((dayTasks.task1 && !dayTasks.task2) || (!dayTasks.task1 && dayTasks.task2)){
                            differenceForTask1 = point.x * 1.5
                            differenceForTask2 = point.x * 1.5
                        }
                        
                        if dayTasks.task1{
                            let viewTask1 = UIView(frame: CGRect(x: point.x + differenceForTask1, y: point.y, width: 3, height: 3))
                            viewTask1.backgroundColor = self.task1Color
                            viewTask1.roundBourdersUntilCircle()
                            dayLabel.addSubview(viewTask1)

                        }
                        if dayTasks.task2{
                            let viewTask2 = UIView(frame: CGRect(x: point.x + differenceForTask2, y: point.y, width: 3, height: 3))
                            viewTask2.backgroundColor = self.task2Color
                            viewTask2.roundBourdersUntilCircle()
                            dayLabel.addSubview(viewTask2)

                        }

                        
                    }
                }
            }
            verticalStack.addArrangedSubview(horizontalStack)

        }
        
        self.content.addSubview(verticalStack)

    }
    
    func getFirstDay(week: WeekNumber, month: Int, year: Int)-> Int{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateTime = formatter.date(from: "\(year)/\(month)/\(1)")
        
        var day = Calendar.current.component(.weekday, from: someDateTime!)
        if self.firstDay == 2{
            day -= 1
            if day == 0 {
                day = 7
            }
        }
        return day
    }
    func numberOfDays(month: Int, year: Int) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateTime = formatter.date(from: "\(year)/\(month)/\(1)")
        
        let daysInMonth = Calendar.current.range(of: .day, in: .month, for: someDateTime!)!.count
    
        let someLastDateTime = formatter.date(from: "\(year)/\(month)/\(daysInMonth)")
        let day = Calendar.current.component(.weekday, from: someLastDateTime!)

        return day
    }
    
    func verifyIfDayHaveTasks(day: Int, month: Int, year: Int) -> DayModel?{
        for dayElement in self.daysWithTasks{
            if ((dayElement.day == day) && (dayElement.month == month) && (dayElement.year == year)){
                return dayElement
            }
        }
        return nil
    }
    func verifyIfDayIsAvailable(day: Int, month: Int, year: Int) -> DayModel?{
        for dayElement in self.notAvailableDays{
            if ((dayElement.day == day) && (dayElement.month == month) && (dayElement.year == year)){
                return dayElement
            }
        }
        return nil
    }
    
}
//MARK: - Calendar functions
extension GMCalendar{
    func verificationForDateUpdate(){
        if currentMonth > 12{
            self.currentYear += 1
            self.currentMonth = 1
        }else if currentMonth < 1 {
            self.currentYear -= 1
            self.currentMonth = 12
        }
    }
}

//MARK: - Animation Functions
extension GMCalendar{
    func animateView(){

        let translate = CGAffineTransform(translationX: 100, y: 100)
        let rotateRight = CGAffineTransform(rotationAngle: 360)
        let rotateLeft = CGAffineTransform(rotationAngle: -360)
        let scale = CGAffineTransform(scaleX: 5, y: 5)
        
        if animation{
            switch animationForMonthUpdate {
            case .zoom:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: self.animationDuration, delay: 0, options: .autoreverse, animations: {
                        self.content.transform = scale
                    }, completion: { _ in
                        self.content.transform = .identity
                    })
                }
            case .xyTraslation:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: self.animationDuration, delay: 0, options: .autoreverse, animations: {
                        self.content.transform = translate
                    }, completion: { _ in
                        self.content.transform = .identity
                    })
                }
            case .rotationRight:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: self.animationDuration, delay: 0, options: .autoreverse, animations: {
                        self.content.transform = rotateRight
                    }, completion: { _ in
                        self.content.transform = .identity
                    })
                }
            case .rotationLeft:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: self.animationDuration, delay: 0, options: .autoreverse, animations: {
                        self.content.transform = rotateLeft
                    }, completion: { _ in
                        self.content.transform = .identity
                    })
                }
            case .rotationRightWithZoom:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: self.animationDuration, delay: 0, options: .autoreverse, animations: {
                        self.content.transform = rotateRight.concatenating(scale)
                    }, completion: { _ in
                        self.content.transform = .identity
                    })
                }
            case .rotationLeftWithZoom:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: self.animationDuration, delay: 0, options: .autoreverse, animations: {
                        self.content.transform = rotateLeft.concatenating(scale)
                    }, completion: { _ in
                        self.content.transform = .identity
                    })
                }
            case .other:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: self.animationDuration, delay: 0, options: .allowUserInteraction, animations: {
                        self.layoutIfNeeded()
                    }, completion: nil)
                }
            }
            
        }
    }
}
//MARK: - Gesture actions
extension GMCalendar{
    func createViewForDaySelected(label: UILabel){
        self.viewForDaySelected?.removeFromSuperview()
        
        let xForView = ((label.bounds.maxX - label.bounds.minX) / 2) - (label.bounds.height / 2)
        
        let viewForDaySelected = UIView(frame: CGRect(x: xForView, y: 0, width: 0, height: 0))
        viewForDaySelected.roundBourdersUntilCircle()
        viewForDaySelected.backgroundColor = self.colorForDaySelected.withAlphaComponent(0.5)
        label.addSubview(viewForDaySelected)
        self.viewForDaySelected = viewForDaySelected
        
        if animation {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.animationDuration / 4, animations: {
                    viewForDaySelected.frame = CGRect(x: xForView, y: 0, width: label.bounds.height, height: label.bounds.height)
                    viewForDaySelected.roundBourdersUntilCircle()
                    viewForDaySelected.layoutIfNeeded()
                })
            }
        }else{
            viewForDaySelected.frame = CGRect(x: xForView, y: 0, width: label.bounds.height, height: label.bounds.height)
            viewForDaySelected.roundBourdersUntilCircle()
        }
    }
    
    @objc func selectedDay(_ sender: Any){
        guard let gesture = sender as? UITapGestureRecognizer else{
            return
        }
        guard let view = gesture.view as? UILabel else{
            return
        }
        var day = 0
        var available = true
        
        if view.text != ""{
            day = Int(view.text!)!
        }
        
        if self.verifyIfDayIsAvailable(day: day, month: self.currentMonth, year: self.currentYear) != nil{
            available = false
        }
        //print("Selected day: ", day)
        self.createViewForDaySelected(label: view)
        self.delegate?.didSelectedDay(view: view, day: day, isAvailable: available)
    }
    @objc func rightArrowSelected(_ sender: Any){
        //print("Right")
        self.currentMonth += 1
        self.verificationForDateUpdate()
        self.updateViewForNewMonth()
        //self.delegate?.didUpdateMonth(view: self, month: currentMonth, year: currentYear)
    }
    @objc func leftArrowSelected(_ sender: Any){
        //print("Left")
        self.currentMonth -= 1
        self.verificationForDateUpdate()
        self.updateViewForNewMonth()
        //self.delegate?.didUpdateMonth(view: self, month: currentMonth, year: currentYear)
    }
    @objc func horizontalLeftSwipe(_ sender: Any){
        //print("Left")
        self.currentMonth += 1
        self.verificationForDateUpdate()
        self.updateViewForNewMonth()
        self.delegate?.didUpdateMonth(view: self, month: currentMonth, year: currentYear)
    }
    @objc func horizontalRightSwipe(_ sender: Any){
        //print("Right")
        self.currentMonth -= 1
        self.verificationForDateUpdate()
        self.updateViewForNewMonth()
        self.delegate?.didUpdateMonth(view: self, month: currentMonth, year: currentYear)
    }
    @objc func verticalTopSwipe(_ sender: Any){
        //print("Top")
        self.currentMonth -= 1
        self.verificationForDateUpdate()
        self.updateViewForNewMonth()
        self.delegate?.didUpdateMonth(view: self, month: currentMonth, year: currentYear)
    }
    @objc func verticalDownSwipe(_ sender: Any){
        //print("Down")
        self.currentMonth += 1
        self.verificationForDateUpdate()
        self.updateViewForNewMonth()
        self.delegate?.didUpdateMonth(view: self, month: currentMonth, year: currentYear)
    }
}
