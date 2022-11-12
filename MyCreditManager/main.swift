import Foundation

let inputValueCheckArray = [1, 2, 3, 4, 5]
var studentInfo: [String : [[String:String]]] = [:]

while true {
    print(GuideString.wantFunctionInput)
    let input = readLine()!
    if input == "X" {
        print("프로그램을 종료합니다...")
        break
    }
    
    if Int(input) != nil && inputValueCheckArray.contains(Int(input)!) {
        myCreditManager(inputValue: Int(input)!)
    } else {
        print(GuideString.errorInput)
    }
}

func myCreditManager(inputValue: Int) {
    switch inputValue {
    case 1:
        addStudent()
        break
    case 2:
        removeStudent()
        break
    case 3:
        addOrChangeGrade()
        break
    case 4:
        removeGrade()
        break
    case 5:
        seeGrade()
        break
    default:
        break
    }
}

func addStudent() {
    print(GuideString.AddStudent.input)
    let input = readLine()!
    if input != "" {
        if studentInfo[input] == nil { // 학생이 없으면
            print("\(input) \(GuideString.AddStudent.success)")
            studentInfo[input] = Array(arrayLiteral: [:])
        } else { // 학생이 있으면
            print("\(input)은 \(GuideString.AddStudent.duplicated)")
        }
    } else {
        print(GuideString.AddStudent.error)
    }
}

func removeStudent() {
    print(GuideString.RemoveStudent.input)
    let input = readLine()!
    if studentInfo[input] == nil { // 학생이 없으면
        print("\(input) 학생을 \(GuideString.RemoveStudent.error)")
    } else { // 학생이 있으면
        studentInfo.removeValue(forKey: input)
        print("\(input) \(GuideString.RemoveStudent.success)")
    }
}

func addOrChangeGrade() {
    print(GuideString.AddOrChangeGrade.input)
    let input = readLine()!.split(separator: " ").map{$0}
    if input.count == 3 {
        let studentName = String(input[0])
        let className = String(input[1])
        let grade = String(input[2])
        
        if studentInfo[studentName] == nil { // 학생이 없으면
            print(GuideString.AddOrChangeGrade.error)
        } else {
            if studentInfo[studentName]!.filter({$0.keys.contains(className)}).isEmpty { // 학생은 있는데 과목성적이 없으면
                studentInfo[studentName]?.append([className : grade])
            } else { // 학생, 과목성적 있으면
                if let index = studentInfo[studentName]?.firstIndex(where: {$0.keys.contains(className)}) {
                    studentInfo[studentName]?[index] = [className : grade]
                }
            }
            print("\(studentName) 학생의 \(className) 과목이 \(grade)로 \(GuideString.AddOrChangeGrade.success)")
        }
    } else {
        print(GuideString.AddOrChangeGrade.error)
    }
}

func removeGrade() {
    print(GuideString.RemoveGrade.input)
    let input = readLine()!.split(separator: " ").map{$0}
    if input.count == 2 {
        let studentName = String(input[0])
        let className = String(input[1])
        if studentInfo[studentName] == nil { // 학생이 없으면
            print("\(studentName) \(GuideString.RemoveGrade.studentSearchFail)")
        } else { // 학생이 있으면
            if let index = studentInfo[studentName]?.firstIndex(where: {$0.keys.contains(className)}) {
                studentInfo[studentName]?.remove(at: index)
            }
            print("\(studentName) 학생의 \(className) 과목의 \(GuideString.RemoveGrade.success)")
        }
    } else {
        print(GuideString.RemoveGrade.error)
    }
}

func seeGrade() {
    print(GuideString.SeeGrade.input)
    let studentName = readLine()!
    if studentName == "" {
        print(GuideString.SeeGrade.error)
    } else {
        if studentInfo[studentName] == nil { // 학생이 없으면
            print("\(studentName) \(GuideString.SeeGrade.studentSearchFail)")
        } else { // 학생이 있으면
            var gradePoint = 0.0
            studentInfo[studentName]?.forEach({
                $0.forEach { className, grade in
                    print("\(className): \(grade)")
                    gradePoint += calPoint(grade: grade)
                }
            })
            print("평점 : \(String(format: "%.2f", gradePoint / Double(studentInfo[studentName]!.count-1)))")
        }
    }
}

func calPoint(grade: String) -> Double {
    switch grade {
    case "A+":
        return 4.5
    case "A":
        return 4.0
    case "B+":
        return 3.5
    case "B":
        return 3.0
    case "C+":
        return 2.5
    case "C":
        return 2.0
    case "D+":
        return 1.5
    case "D":
        return 1.0
    case "F":
        return 0.0
    default:
        return 0.0
    }
}

struct GuideString {
    static let wantFunctionInput = "원하는 기능을 입력해주세요 \n1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료"
    static let errorInput = "뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요."
    
    struct AddStudent {
        static let input = "추가할 학생의 이름을 입력해주세요."
        static let success = "학생을 추가했습니다."
        static let duplicated = "이미 존재하는 학생입니다. 추가하지 않습니다."
        static let error = "입력이 잘못되었습니다. 다시 확인해주세요."
    }
    struct RemoveStudent {
        static let input = "삭제할 학생의 이름을 입력해주세요."
        static let success = "학생을 삭제하였습니다."
        static let error = "학생을 찾지 못했습니다."
    }
    struct AddOrChangeGrade {
        static let input = "성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요. \n입력예) Mickey Swift A+ \n만약에 학생의 성적 중 과목이 존재하면 기존 점수가 갱신됩니다."
        static let success = "추가(변경)되었습니다."
        static let error = "입력이 잘못되었습니다. 다시 확인해주세요."
    }
    struct RemoveGrade {
        static let input = "성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요. \n입력예) Mickey Swift"
        static let success = "성적이 삭제되었습니다."
        static let studentSearchFail = "학생을 찾지 못했습니다."
        static let error = "입력이 잘못되었습니다. 다시 확인해주세요."
    }
    struct SeeGrade {
        static let input = "평점을 알고싶은 학생의 이름을 입력해주세요."
        static let studentSearchFail = "학생을 찾지 못했습니다."
        static let error = "입력이 잘못되었습니다. 다시 확인해주세요."
    }
}
