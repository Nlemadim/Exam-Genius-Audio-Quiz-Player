//
//  Misc.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/23/24.
//

import Foundation
import SwiftUI
import Speech

struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect?

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect)
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}

enum WordProcessor: String {
    case A, B, C, D

    static func processWords(from transcript: String) -> String {
        let lowercasedTranscript = transcript.lowercased()

        switch lowercasedTranscript {
        case "a", "eh", "ay", "hey", "ea", "hay", "aye":
            return WordProcessor.A.rawValue
        case "b", "be", "bee", "beat", "bei", "bead", "bay", "bye", "buh":
            return WordProcessor.B.rawValue
        case "c", "see", "sea", "si", "cee", "seed":
            return WordProcessor.C.rawValue
        case "d", "dee", "the", "di", "dey", "they":
            return WordProcessor.D.rawValue
        default:
            return "" // or return a default value or handle the error
        }
    }
}

enum InteractionState {
    case isNowPlaying
    case isListening
    case isProcessing
    case errorResponse
    case awaitingResponse
    case hasResponded
    case idle
    case successfulResponse
    
    var status: String {
        switch self {
        case .isNowPlaying:
            return "Now playing"
        case .isListening:
            return "Listening"
        case .errorResponse:
            return "Error response"
        case .hasResponded:
            return "Recieved a response"
        case .idle:
            return "Start"
        case .isProcessing:
            return "Processing"
        case .awaitingResponse:
            return "Waiting for response"
        case .successfulResponse:
            return "Response successfully processed"
        }
    }
}



//MARK: SERVER RESPONSE OBJECT (TOPICS REQUEST)
/** Response HTTP Status code: 200
 Raw server response: {"topics":["Constitutional Law","Constitutional Law - Bill of Rights","Constitutional Law - Separation of Powers","Constitutional Law - Federalism","Constitutional Law - Individual Rights","Criminal Law","Criminal Law - Crimes Against the Person","Criminal Law - Crimes Against Property","Criminal Law - Inchoate Crimes","Criminal Law - Defenses","Criminal Procedure","Criminal Procedure - Fourth Amendment","Criminal Procedure - Fifth Amendment","Criminal Procedure - Sixth Amendment","Real Property Law","Real Property Law - Land Ownership","Real Property Law - Landlord-Tenant Law","Real Property Law - Real Estate Transactions","Torts","Torts - Intentional Torts","Torts - Negligence","Torts - Strict Liability","Torts - Defamation","Torts - Privacy Torts","Evidence","Evidence - Relevancy","Evidence - Hearsay","Evidence - Privileges","Evidence - Presentation of Evidence","Civil Procedure","Civil Procedure - Jurisdiction","Civil Procedure - Pleadings","Civil Procedure - Pretrial Procedures,"]}
 
 ACT Exam
 Response HTTP Status code: 200
 Raw server response: {"topics":["English Grammar Rules","Reading Comprehension Techniques","Essay Writing Skills","Basic Algebra","Intermediate Algebra","Advanced Algebra","Coordinate Geometry","Plane Geometry","Trigonometry","Data Analysis","Probability","Statistics","Scientific Notation","Fundamentals of Chemistry","Fundamentals of Physics","Fundamentals of Biology","Fundamentals of Earth Science","Vocabulary Expansion","Sentence Completion Strategies","Reading Speed Improvement","Reading for Main Idea","Identifying Supporting Details","Making Logical Inferences","Recognizing Sequence of Events","Identifying Cause and Effect Relationships","Understanding Comparative Relationships","Interpreting Figures of Speech","Understanding Author's Tone and Purpose","Recognizing Organization and Structure of Text","Interpreting Expository Texts","Interpreting Narrative Texts","Interpreting Persuasive Texts","Understanding Complex Characters","Plot and Setting Analysis","Theme Identification","Understanding Literary Devices","Understanding Experimental Design in Science","Interpreting Scientific Graphs and Tables","Evaluating Scientific Hypotheses","Predictions","and Conclusions","Understanding"]}
 
 AWS Certified Solutions Architect Exam
 Response HTTP Status code: 200
 Raw server response: {"topics":["Amazon Web Services (AWS) Overview","AWS Global Infrastructure","AWS Management Console","AWS CLI","AWS SDKs","Identity and Access Management (IAM)","Amazon Simple Storage Service (S3)","Amazon Glacier","Amazon Elastic Block Store (EBS)","Amazon Elastic File System (EFS)","Amazon EC2 Instances","Amazon EC2 Auto Scaling","Amazon Elastic Load Balancing","Amazon Virtual Private Cloud (VPC)","AWS Direct Connect","Amazon Route 53","AWS CloudFront","Amazon RDS","Amazon DynamoDB","Amazon ElastiCache","Amazon Redshift","Amazon Athena","Amazon QuickSight","Amazon EMR","AWS Glue","AWS Lambda","AWS Step Functions","Amazon SNS","Amazon SQS","Amazon SWF","Amazon MQ","AWS Application Integration","AWS CloudFormation","AWS CloudTrail","Amazon CloudWatch","AWS Config","AWS OpsWorks","AWS Service Catalog","AWS Systems Manager","AWS Trusted Advisor","AWS Well-Architected Framework","AWS Security Best Practices","AWS Compliance"]}
 
 Certified Information Systems Auditor Exam
 Response HTTP Status code: 200
 Raw server response: {"topics":["Information Systems Auditing Process","Developing and Implementing an Audit Strategy","Conducting an IS Audit","Documenting Audit Results","Audit Standards","Guidelines and Codes of Ethics","Risk Analysis","Risk Management","Control Self-Assessment","Business Process Evaluation and Risk Management","Types of Controls","Business Continuity Planning","Disaster Recovery Planning","Systems Infrastructure Control","Data Encryption","Network Security","Firewall and VPN Management","Intrusion Detection and Prevention","Business Continuity and Disaster Recovery","Data Backup Strategies","Data Recovery Strategies","IT Governance","IT Strategy and Policy","IT Management and Leadership","IT Service Delivery and Support","IT Infrastructure","Hardware","and Software","Information Security Management","Network Architecture and Design","Physical and Environmental Security","System Access Control","Data Classification Standards","Privacy Principles","Incident Management","IT Service Level Management","IT Operations","IT Project Management","IT Quality Assurance","Software Development","Acquisition","and Maintenance","System Development Life Cycle (SDLC)","Business Application Systems","Business Information Systems","Enterprise Architecture","Data"]}
 
 Response HTTP Status code: 200
 Raw server response: {"topics":["1. AP English Literature and Composition: Understanding of Prose","2. AP English Literature and Composition: Understanding of Poetry","3. AP English Literature and Composition: Literary Analysis","4. AP English Literature and Composition: Writing Skills","5. AP English Language and Composition: Rhetorical Analysis","6. AP English Language and Composition: Argumentation","7. AP English Language and Composition: Synthesis of Information","8. AP English Language and Composition: Grammar and Usage","9. AP Calculus AB: Limits and Continuity","10. AP Calculus AB: Derivatives","11. AP Calculus AB: Integrals","12. AP Calculus AB: Polynomial Approximations and Series","13. AP Calculus BC: Parametric","Polar","and Vector Functions","14. AP Calculus BC: Infinite Sequences and Series","15. AP Calculus BC: Differential Equations","16. AP"]}
 ContentBuilder has created: 18 Topics
 
 
 
 CERTFIED FRAUD EXAMINER
 Response HTTP Status code: 200
 Raw server response: {"topics":["Fraud Prevention and Deterrence","Fraudulent Financial Transactions","Fraud Schemes","Types of Fraud","Fraud Risk Factors","Legal Elements of Fraud","Fraud Prevention Measures","Corporate Governance for Fraud Prevention","Fraud Risk Assessment","Data Analysis Techniques for Fraud Detection","Fraud Investigation Methods","Fraud Investigation Techniques","Interviewing Techniques for Fraud Investigation","Fraud Case Management","Law Related to Fraud","Fraud Trial","Fraud Resolution","Ethical Issues in Fraud Examination","Fraud and Technology","Digital Forensics in Fraud Examination","Cyber Fraud Tactics","Fraud Detection in E-commerce","Fraud in Financial Statements","Occupational Fraud","Bankruptcy Fraud","Credit Card Fraud","Insurance Fraud","Securities Fraud","Identity Theft","Money Laundering","Bribery and Corruption","Asset Misappropriation","Check Tampering","Payroll Fraud","Expense Reimbursement Fraud","Financial Statement Fraud","Internal Controls to Prevent Fraud","Auditing and Fraud Detection","Role of Auditors in Detecting Fraud","Ethics and Fraud","Whistleblowing in Fraud Detection"]}
 ContentBuilder has created: 41 Topics
 
 Building test Content
 Response HTTP Status code: 200
 Raw server response: {"topics":["Fraud Prevention and Deterrence","Fraudulent Financial Transactions","Fraud Investigation Methods","Legal Elements of Fraud","Criminology and Ethics","Understanding the Law Related to Fraud","Types of Fraud","Fraud Risk Assessment","Data Analysis Techniques for Fraud Detection","Fraud Prevention Techniques","Corporate Governance for Fraud Prevention","Internal Controls to Deter Fraud","Ethics and Fraud","Fraud Case Management","Interviewing Techniques for Fraud Investigations","Document Examination in Fraud Investigations","Digital Forensics in Fraud Investigations","Testifying as an Expert Witness in Fraud Cases","Fraud and the Internet","Identity Theft and Fraud","Credit Card Fraud","Bankruptcy Fraud","Insurance Fraud","Health Care Fraud","Securities Fraud","Tax Fraud","Money Laundering","Bribery and Corruption","Fraud in Non-Profit Organizations","Occupational Fraud","Cyber Fraud","Real Estate and Mortgage Fraud","Intellectual Property Fraud","Fraud Detection in E-commerce","Fraud in the Public Sector","Fraud in Small Businesses","Forensic Accounting","Use of Technology in Fraud Examination","Fraud Response"]}
 Starting fetchQuestionData for examName: Certified Fraud Examiner with topics: ["Testifying as an Expert Witness in Fraud Cases"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Certified%20Fraud%20Examiner&topicValue=Testifying%20as%20an%20Expert%20Witness%20in%20Fraud%20Cases&numberValue=3
 
 Raw Response: {
   "examName": "ACT Exam",
   "topics": [
     "Narrative Writing"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is NOT a characteristic of narrative writing?",
       "options": {
         "A": "Incorporates characters",
         "B": "Follows a chronological sequence",
         "C": "Includes thesis statement",
         "D": "Contains a plot with conflict"
       },
       "correctOption": "C",
       "overview": "Narrative writing tells a story or part of a story. It incorporates characters, follows a chronological sequence, and contains a plot with conflict. Unlike expository or persuasive writing, it does not typically include a thesis statement."
     },
     {
       "questionNumber": 2,
       "question": "What is the primary purpose of dialogue in narrative writing?",
       "options": {
         "A": "To provide non-essential information",
         "B": "To describe the setting in detail",
         "C": "To reveal character traits and advance the plot",
         "D": "To list the events in chronological order"
       },
       "correctOption": "C",
       "overview": "In narrative writing, dialogue is used to reveal character traits and advance the plot. It helps in showing the interactions between characters, thereby adding depth to the narrative and moving the story forward."
     },
     {
       "questionNumber": 3,
       "question": "Which point of view is most commonly used in narrative writing?",
       "options": {
         "A": "First person",
         "B": "Second person",
         "C": "Third person omniscient",
         "D": "Third person limited"
       },
       "correctOption": "A",
       "overview": "The first person point of view is most commonly used in narrative writing. It allows the writer to directly engage with the reader by sharing personal experiences, thoughts, and emotions, making the story more intimate and relatable."
     }
   ]
 }
 
 Raw Response: {
   "examName": "Cybersecurity Analyst Exam",
   "topics": [
     "Wireless Network Security"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following encryption protocols is considered the most secure for wireless networks?",
       "options": {
         "A": "WEP",
         "B": "WPA",
         "C": "WPA2",
         "D": "TKIP"
       },
       "correctOption": "C",
       "overview": "WPA2 (Wi-Fi Protected Access 2) is currently considered the most secure encryption protocol for wireless networks. It provides stronger data protection and network access control than its predecessors, WEP (Wired Equivalent Privacy) and WPA (Wi-Fi Protected Access), and uses AES (Advanced Encryption Standard) which is a more secure encryption algorithm. TKIP (Temporal Key Integrity Protocol) was used with WPA for encryption but is also not as secure as AES used with WPA2."
     },
     {
       "questionNumber": 2,
       "question": "What is the primary purpose of using a VPN on a wireless network?",
       "options": {
         "A": "To increase the network's speed",
         "B": "To create a secure tunnel for data transmission",
         "C": "To replace the need for encryption",
         "D": "To broadcast multiple SSIDs"
       },
       "correctOption": "B",
       "overview": "The primary purpose of using a VPN (Virtual Private Network) on a wireless network is to create a secure tunnel for data transmission. This secure tunnel encrypts data as it travels between the client and the network, enhancing privacy and security, especially on public Wi-Fi networks. It does not inherently increase network speed, replace the need for encryption on the wireless network itself, or broadcast multiple SSIDs."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following is a common security threat to wireless networks?",
       "options": {
         "A": "Phishing",
         "B": "SQL Injection",
         "C": "Evil Twin",
         "D": "Cross-site scripting"
       },
       "correctOption": "C",
       "overview": "An 'Evil Twin' attack is a common security threat specific to wireless networks. In this attack, a malicious actor sets up a fake wireless access point (AP) mimicking a legitimate one, with the intention of deceiving users into connecting to it. Once connected, the attacker can intercept the data transferred by the user, potentially gaining access to sensitive information. Phishing, SQL Injection, and Cross-site scripting are security threats too but are not specific to wireless networks."
     }
   ]
 }
 
 Raw Response: {
   "examName": "Certified Fraud Examiner",
   "topics": [
     "Testifying as an Expert Witness in Fraud Cases"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is NOT a key quality of an effective expert witness in fraud cases?",
       "options": {
         "A": "Ability to simplify complex information",
         "B": "Having a bias towards the hiring party",
         "C": "Strong communication skills",
         "D": "Credibility and professionalism"
       },
       "correctOption": "B",
       "overview": "An effective expert witness in fraud cases must be able to simplify complex information, have strong communication skills, and maintain credibility and professionalism. Having a bias towards the hiring party undermines the expert's credibility and is not a key quality."
     },
     {
       "questionNumber": 2,
       "question": "What is the primary purpose of an expert witness's testimony in a fraud case?",
       "options": {
         "A": "To prove the guilt of the defendant",
         "B": "To provide specialized knowledge to help the trier of fact understand the evidence or determine a fact in issue",
         "C": "To replace the jury in decision making",
         "D": "To advocate for the hiring party"
       },
       "correctOption": "B",
       "overview": "The primary purpose of an expert witness's testimony in a fraud case is to provide specialized knowledge to help the trier of fact (judge or jury) understand the evidence or determine a fact in issue, not to advocate for any party or replace the jury in decision making."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following best describes the 'Daubert Standard'?",
       "options": {
         "A": "A rule that allows expert witnesses to testify without being cross-examined",
         "B": "A guideline for determining the admissibility of expert witness testimony",
         "C": "A legal principle that prohibits the use of expert witnesses in fraud cases",
         "D": "A standard for evaluating the financial damages in a fraud case"
       },
       "correctOption": "B",
       "overview": "The 'Daubert Standard' is a guideline set by the Supreme Court for determining the admissibility of expert witness testimony. It requires that the testimony is based on sufficient facts or data, is the product of reliable principles and methods, and the expert has applied the principles and methods reliably to the facts of the case."
     }
   ]
 }
 
 Certified Public Accountant Exam
 {"topics":["Auditing and Attestation","Understanding Auditing Procedures","Understanding Auditing Standards","Understanding Internal Controls","Understanding Sampling Methods","Business Environment and Concepts","Corporate Governance","Economics","Financial Management","Information Systems and Communications","Strategic Planning","Operations Management","Financial Accounting and Reporting","Conceptual Frameworks in Accounting","Financial Statement Accounts","Specific Transactions and Events","State and Local Governments","Regulation","Ethics and Professional Responsibilities","Business Law","Federal Taxation","Federal Tax for Entities","Business Structure","Financial Statement Analysis","Cost Accounting","Managerial Accounting","Forensic Accounting","International Financial Reporting Standards","Internal Auditing","Risk Assessment and Assurance","Tax Planning and Compliance","Business Combinations","Non-profit Accounting","Governmental Accounting","Accounting for Income Taxes","Pensions and Other Employee Benefits","Share-based Compensation and Earnings per Share","Accounting Changes and Error Corrections","The Fair Value Measurement","Non-monetary Transactions","Investments","Cash and Receivables","Inventory","Property","Plant","and Equipment","Leases,"]}
 Raw Response: {
   "examName": "Certified Public Accountant Exam",
   "topics": [
     "Auditing and Attestation"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following best describes the primary objective of financial statement auditing?",
       "options": {
         "A": "Detection and prevention of fraud",
         "B": "Assurance on the accuracy of financial statements",
         "C": "Compliance with tax laws",
         "D": "Evaluation of financial statement presentation"
       },
       "correctOption": "B",
       "overview": "The primary objective of financial statement auditing is to provide assurance that the financial statements are free from material misstatement, whether caused by error or fraud. This helps users of the financial statements, such as investors and creditors, make informed decisions."
     },
     {
       "questionNumber": 2,
       "question": "Which of the following represents a type of audit evidence?",
       "options": {
         "A": "Physical examination",
         "B": "Management's opinion",
         "C": "Future financial projections",
         "D": "Advertising brochures"
       },
       "correctOption": "A",
       "overview": "Audit evidence is all the information used by the auditor in arriving at the conclusions on which the audit opinion is based. Physical examination, also known as inspection, is a type of audit evidence where the auditor physically examines assets, documents, or records."
     },
     {
       "questionNumber": 3,
       "question": "What is the purpose of an auditor's report?",
       "options": {
         "A": "To provide an opinion on the effectiveness of internal control",
         "B": "To describe the scope of the audit",
         "C": "To express an opinion on the financial statements",
         "D": "To highlight areas for financial improvement"
       },
       "correctOption": "C",
       "overview": "The purpose of an auditor's report is to express an opinion on whether the financial statements are prepared, in all material respects, in accordance with an applicable financial reporting framework. This opinion helps users of the financial statements understand whether they can rely on the financial statements for making decisions."
     }
   ]
 }

 
 {
  "examName": "Kotlin Programming Language",
  "topics": [
    "Kotlin Reflection"
  ],
  "questions": [
    {
      "questionNumber": 1,
      "question": "What is the purpose of reflection in Kotlin?",
      "options": {
        "A": "To observe changes in program state",
        "B": "To manipulate classes, functions, and properties at runtime",
        "C": "To improve compilation time",
        "D": "To facilitate asynchronous programming"
      },
      "correctOption": "B",
      "overview": "Reflection in Kotlin is used to manipulate classes, functions, and properties at runtime. It allows the program to inspect or modify itself, providing a way to dynamically access objects and their members."
    },
    {
      "questionNumber": 2,
      "question": "Which of the following is a reflection API in Kotlin?",
      "options": {
        "A": "KClass",
        "B": "Kotlinx",
        "C": "KFunction",
        "D": "All of the above"
      },
      "correctOption": "D",
      "overview": "Kotlin's reflection API includes KClass, KFunction, and other interfaces such as KProperty. These are used to access metadata of classes, functions, and properties."
    },
    {
      "questionNumber": 3,
      "question": "How can you obtain a reference to a class in Kotlin using reflection?",
      "options": {
        "A": "::class syntax",
        "B": "Class.forName() method",
        "C": "Using the new keyword",
        "D": "Kotlin does not support class references"
      },
      "correctOption": "A",
      "overview": "In Kotlin, a reference to a class can be obtained using the ::class syntax. This is part of Kotlin's reflection capabilities, allowing you to access the class's metadata at runtime."
    }
  ]
}
 
 Raw Response: {
   "examName": "AWS Certified Solutions Architect Exam",
   "topics": [
     "AWS Compute Services"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which AWS service allows you to run code without provisioning or managing servers?",
       "options": {
         "A": "Amazon EC2",
         "B": "AWS Lambda",
         "C": "Amazon ECS",
         "D": "Amazon Lightsail"
       },
       "correctOption": "B",
       "overview": "AWS Lambda is a serverless compute service that lets you run code without provisioning or managing servers. It executes your code only when needed and scales automatically, from a few requests per day to thousands per second."
     },
     {
       "questionNumber": 2,
       "question": "Which of the following is a fully managed container orchestration service?",
       "options": {
         "A": "Amazon EC2",
         "B": "AWS Elastic Beanstalk",
         "C": "Amazon ECS",
         "D": "Amazon RDS"
       },
       "correctOption": "C",
       "overview": "Amazon ECS (Elastic Container Service) is a fully managed container orchestration service. Customers such as Duolingo, Samsung, GE, and Cookpad use ECS to run their most sensitive and mission-critical applications because of its security, reliability, and scalability."
     },
     {
       "questionNumber": 3,
       "question": "Which AWS service provides scalable and secure global compute edge locations?",
       "options": {
         "A": "AWS Global Accelerator",
         "B": "Amazon CloudFront",
         "C": "AWS Outposts",
         "D": "Amazon EC2 Auto Scaling"
       },
       "correctOption": "B",
       "overview": "Amazon CloudFront is a fast content delivery network (CDN) service that securely delivers data, videos, applications, and APIs to customers globally with low latency, high transfer speeds, all within a developer-friendly environment."
     }
   ]
 }
 
 Raw Response: {
   "examName": "Dental Admission Test",
   "topics": [
     "Dental Radiography"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following radiographic techniques is used to visualize the entire tooth (crown and root) and the surrounding bone?",
       "options": {
         "A": "Bitewing",
         "B": "Periapical",
         "C": "Occlusal",
         "D": "Panoramic"
       },
       "correctOption": "B",
       "overview": "Periapical radiography is the technique of choice when the goal is to visualize the entire tooth (crown and root) along with the surrounding bone. This is crucial for diagnosing conditions like periapical abscesses or cysts, and for assessing the extent of periodontal disease."
     },
     {
       "questionNumber": 2,
       "question": "What is the primary purpose of using a bitewing radiograph in dental diagnostics?",
       "options": {
         "A": "To detect periodontal disease",
         "B": "To examine the nasal cavity",
         "C": "To detect interproximal caries",
         "D": "To evaluate jaw fractures"
       },
       "correctOption": "C",
       "overview": "Bitewing radiographs are primarily used to detect interproximal caries, which are not easily visible during a clinical examination. They can also be useful in assessing the bone level in the case of periodontal disease, but their main purpose is the early detection of caries between teeth."
     },
     {
       "questionNumber": 3,
       "question": "Which type of radiation is most commonly used in dental radiography?",
       "options": {
         "A": "Gamma rays",
         "B": "Ultraviolet radiation",
         "C": "X-rays",
         "D": "Microwaves"
       },
       "correctOption": "C",
       "overview": "X-rays are the type of radiation most commonly used in dental radiography. They have the ability to penetrate tissues and structures, creating images that help in diagnosing a wide range of dental conditions, from cavities and gum disease to impacted teeth and jaw abnormalities."
     }
   ]
 }
 
 /////////
 Response HTTP Status code: 200
 Raw server response: {"topics":["Auditing and Attestation","Understanding Auditing Procedures","Understanding Attestation Procedures","Audit Reports","Internal Controls","Compliance with Laws and Regulations in an Audit","Ethics","Professional Responsibilities","and General Principles","Assessing Risk and Developing a Planned Response","Performing Further Procedures and Obtaining Evidence","Forming Conclusions and Reporting","Business Environment and Concepts","Corporate Governance","Economic Concepts and Analysis","Financial Management","Information Technology","Operations Management","Financial Reporting","Conceptual Framework and Financial Reporting","Select Financial Statement Accounts","Select Transactions","State and Local Governments","Regulation","Ethics","Professional Responsibilities","and Federal Tax Procedures","Business Law","Federal Taxation of Property Transactions","Federal Taxation of Individuals","Federal Taxation of Entities","Business Environment and Concepts","Corporate Governance","Economic Concepts and Analysis","Financial Management","Information Systems and Communications","Strategic Planning","Operations Management","Financial Accounting and Reporting","Conceptual Framework","Standard-Setting and Financial Reporting","Select Financial Statement Accounts","Select Transactions","State and Local Governments"]}
 Starting fetchQuestionData for examName: Certified Public Accountant with topics: ["Financial Accounting and Reporting"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Certified%20Public%20Accountant&topicValue=Financial%20Accounting%20and%20Reporting&numberValue=3
 Raw Response: {
   "examName": "Certified Public Accountant",
   "topics": [
     "Financial Accounting and Reporting"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following statements is true regarding IFRS and U.S. GAAP?",
       "options": {
         "A": "IFRS requires development costs to be expensed when incurred.",
         "B": "U.S. GAAP allows for revaluation of plant, property, and equipment.",
         "C": "IFRS does not allow for inventory to be written down.",
         "D": "U.S. GAAP requires development costs to be capitalized if certain criteria are met."
       },
       "correctOption": "D",
       "overview": "Under U.S. GAAP, development costs can be capitalized if certain criteria are met, allowing these costs to be amortized over their useful life. This contrasts with IFRS, which generally requires development costs to be expensed as incurred unless they meet specific criteria for capitalization."
     },
     {
       "questionNumber": 2,
       "question": "How is comprehensive income defined?",
       "options": {
         "A": "Net income plus other comprehensive income.",
         "B": "Gross income minus operating expenses.",
         "C": "Total revenue minus total expenses.",
         "D": "Net income adjusted for changes in equity."
       },
       "correctOption": "A",
       "overview": "Comprehensive income is defined as net income plus other comprehensive income. Other comprehensive income includes revenues, expenses, gains, and losses that are not included in net income and are instead listed in a separate section of a company's equity."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following is not a characteristic of a liability?",
       "options": {
         "A": "It involves a transfer of assets or services at a future date.",
         "B": "It is a present obligation.",
         "C": "It results from past transactions or events.",
         "D": "It must have a fixed and determinable amount."
       },
       "correctOption": "D",
       "overview": "While many liabilities have a fixed and determinable amount, this is not a required characteristic for a financial obligation to be classified as a liability. Liabilities can also include estimated amounts, such as provisions for warranties or lawsuits."
     }
   ]
 }
 
 
 ////////Cisco Certified Network Associate Exam
 Response HTTP Status code: 200
 Raw server response: {"topics":["Network Fundamentals","Network Media Types","OSI and TCP/IP Models","IP Addressing (IPv4 / IPv6)","IP Routing Technologies","IP Services (DHCP","NAT","ACLs)","Network Device Security","Troubleshooting","LAN Switching Technologies","WAN Technologies","Infrastructure Services","Infrastructure Security","Infrastructure Management","Understanding Ethernet","Understanding Switches","VLANs and Trunking","Spanning Tree Protocol (STP)","EtherChannel","Layer 3 Switching","IP Addressing and Subnetting","Routing Protocol Concepts","Static Routing","Dynamic Routing","Inter-VLAN Routing","Access Control Lists (ACLs)","DHCP","Network Address Translation (NAT)","Network Device Management","Device Monitoring","Cisco Licensing","Understanding Binary","Hexadecimal","and Decimal","Understanding Data Networks","Building a Simple Network","Establishing Internet Connectivity","Managing Network Device Security","Building a Medium-Sized Network","Introducing IPv6","Building a Simple Network","Establishing Internet Connectivity","Building a Medium-Sized Network"]}
 Starting fetchQuestionData for examName: Cisco Certified Network Associate Exam with topics: ["Layer 3 Switching"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Cisco%20Certified%20Network%20Associate%20Exam&topicValue=Layer%203%20Switching&numberValue=3
 Raw Response: {
   "examName": "Cisco Certified Network Associate Exam",
   "topics": [
     "Layer 3 Switching"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following best describes Layer 3 switching?",
       "options": {
         "A": "The process of making switching decisions based on MAC addresses.",
         "B": "The process of making switching decisions based on IP addresses.",
         "C": "The process of forwarding packets based on their VLAN tags.",
         "D": "The use of a routing protocol to determine the best path."
       },
       "correctOption": "B",
       "overview": "Layer 3 switching refers to the process of making switching decisions based on IP addresses. Unlike Layer 2 switching, which uses MAC addresses to forward data to the correct destination within a LAN, Layer 3 switching involves routing packets to their destination across different networks, utilizing IP addresses for this purpose."
     },
     {
       "questionNumber": 2,
       "question": "What is a major benefit of using Layer 3 switches in a network?",
       "options": {
         "A": "They reduce the need for routers.",
         "B": "They increase the network's broadcast domain.",
         "C": "They solely rely on MAC addresses for data forwarding.",
         "D": "They support higher data transmission rates than routers."
       },
       "correctOption": "A",
       "overview": "A major benefit of using Layer 3 switches in a network is that they reduce the need for routers. Layer 3 switches can perform many of the same functions as routers, including routing packets between different subnets, which can simplify network design and reduce equipment costs."
     },
     {
       "questionNumber": 3,
       "question": "Which feature is most commonly associated with Layer 3 switches?",
       "options": {
         "A": "Quality of Service (QoS)",
         "B": "Virtual LANs (VLANs)",
         "C": "Routing Information Protocol (RIP)",
         "D": "Static Routing"
       },
       "correctOption": "D",
       "overview": "Static Routing is most commonly associated with Layer 3 switches. While Layer 3 switches support dynamic routing protocols, static routing is often used in simpler networks where routes do not change often. This allows for efficient routing of traffic without the overhead of dynamic routing protocols."
     }
   ]
 }
 
 
 
 ////////Certified Public Accountant
 Response HTTP Status code: 200
 Raw server response: {"topics":["Financial Accounting and Reporting","Understanding Generally Accepted Accounting Principles (GAAP)","Understanding International Financial Reporting Standards (IFRS)","Business Income Statement","Statement of Cash Flows","Balance Sheet Analysis","Non-for-profit accounting","Governmental accounting","Pension Plans","Share-based Compensation","Business Combinations","Accounting Changes and Error Corrections","Income Taxes","Investments","Property","Plant","and Equipment","Intangible Assets","Current Liabilities and Contingencies","Long-Term Liabilities","Equity","Revenue Recognition","Leases","Derivatives and Hedging","Fair Value Measurements","Distinguishing between Operating and Non-Operating Income","Accounting for Income Taxes","Earnings per Share","Accounting for Stock-based Compensation","Accounting for Business Combinations","Preparation of Financial Statements","Disclosure in Financial Reporting","Specific Transactions and Events","Accounting for Non-Profit Organizations","Accounting for Government Entities","Auditing and Attestation","Internal Controls","Evidence","Audit Documentation","Reports","Accounting and Review Service Engagements","Professional Responsibilities","Ethics"]}
 Starting fetchQuestionData for examName: Certified Public Accountant with topics: ["Internal Controls"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Certified%20Public%20Accountant&topicValue=Internal%20Controls&numberValue=3
 Raw Response: {
   "examName": "Certified Public Accountant",
   "topics": [
     "Internal Controls"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is NOT a component of internal control according to the COSO framework?",
       "options": {
         "A": "Risk Assessment",
         "B": "Information and Communication",
         "C": "Monitoring Activities",
         "D": "Cost-Benefit Analysis"
       },
       "correctOption": "D",
       "overview": "The COSO framework identifies five components of internal control: control environment, risk assessment, control activities, information and communication, and monitoring activities. Cost-Benefit Analysis is not listed as a component of internal control by COSO."
     },
     {
       "questionNumber": 2,
       "question": "What is the primary purpose of segregation of duties in internal control systems?",
       "options": {
         "A": "To ensure that no single individual has control over all phases of a transaction",
         "B": "To increase efficiency within the organization",
         "C": "To comply with tax regulations",
         "D": "To facilitate employee training"
       },
       "correctOption": "A",
       "overview": "The primary purpose of segregation of duties within internal control systems is to prevent fraud and errors. This is achieved by ensuring that no single individual has control over all phases of a transaction, thereby reducing the risk of unauthorized actions."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following best describes the 'control environment'?",
       "options": {
         "A": "It involves the procedures that ensure that management's directives are carried out.",
         "B": "It is the set of standards, processes, and structures that provide the basis for carrying out internal control across the organization.",
         "C": "It includes the necessary actions to detect, prevent, and correct fraud and errors.",
         "D": "It refers to the mechanism for tracking the performance of the organization against its goals."
       },
       "correctOption": "B",
       "overview": "The 'control environment' is the foundation of the COSO framework's five components of internal control. It sets the tone of an organization, influencing the control consciousness of its people. It is the basis for all other components of internal control, providing discipline and structure."
     }
   ]
 }
 
 
 
 //////
 Response HTTP Status code: 200
 Raw server response: {"topics":["Architectural Design Principles","Architectural History","Building Codes and Regulations","Site Planning","Building Systems Integration","Environmental Systems","Structural Systems","Construction Documentation","Building Materials and Assemblies","Sustainability in Architecture","Architectural Theories","Urban Design","Architectural Graphics and Visualization","Project Management in Architecture","Architectural Programming","Building Economics","Professional Practice Ethics","Accessibility and Universal Design","Adaptive Reuse","Building Information Modeling (BIM)","Construction Project Management","Building Envelope Systems","Space Planning","Interior Architecture","Acoustics in Architecture","Lighting Design","Fire Protection Systems","Plumbing Systems","HVAC Systems","Electrical Systems","Security and Safety Considerations","Architectural Research Methods","Design Thinking","Landscape Architecture","Architectural Technology","Contract Documents and Administration","Cost Estimation","Project Delivery Methods","Risk Management in Architecture","Historic Preservation","Furniture Design","Zoning Laws","Residential Design","Commercial Design","Institutional Design","Industrial Design","Building Resilience","Human Behavior in Built Environment","Building Codes and Ins"]}
 Starting fetchQuestionData for examName: Architect Registration Exam with topics: ["Plumbing Systems"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Architect%20Registration%20Exam&topicValue=Plumbing%20Systems&numberValue=3
 Raw Response: {
   "examName": "Architect Registration Exam",
   "topics": [
     "Plumbing Systems"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which type of pipe is most suitable for carrying drinking water?",
       "options": {
         "A": "Galvanized Steel",
         "B": "Copper",
         "C": "PVC",
         "D": "ABS"
       },
       "correctOption": "B",
       "overview": "Copper pipes are most suitable for carrying drinking water because they do not release harmful substances or corrode easily, ensuring the water remains clean and safe to drink."
     },
     {
       "questionNumber": 2,
       "question": "What is the primary purpose of a trap in plumbing systems?",
       "options": {
         "A": "To regulate water pressure",
         "B": "To prevent backflow",
         "C": "To prevent sewer gases from entering the building",
         "D": "To reduce water consumption"
       },
       "correctOption": "C",
       "overview": "The primary purpose of a trap in plumbing systems is to prevent sewer gases from entering the building. It does this by holding a small amount of water in a U-shaped section, blocking the gases."
     },
     {
       "questionNumber": 3,
       "question": "Which plumbing system component is responsible for removing waste water and materials from a building?",
       "options": {
         "A": "Water supply system",
         "B": "Drain-Waste-Vent (DWV) system",
         "C": "Stormwater system",
         "D": "Potable water system"
       },
       "correctOption": "B",
       "overview": "The Drain-Waste-Vent (DWV) system is responsible for removing waste water and materials from a building. It ensures that waste is efficiently carried away from fixtures, preventing clogs and maintaining sanitation."
     }
   ]
 }
 
 /////Advanced Placement Exams
 Response HTTP Status code: 200
 Raw server response: {"topics":["AP Biology: Cellular Processes","AP Biology: Evolution","AP Biology: Organismal Biology","AP Biology: Ecology","AP Biology: Genetics","AP Biology: Biological Systems Interactions","AP Biology: Lab Skills,"]}
 Starting fetchQuestionData for examName: Advanced Placement Exams with topics: ["AP Biology: Biological Systems Interactions"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Advanced%20Placement%20Exams&topicValue=AP%20Biology:%20Biological%20Systems%20Interactions&numberValue=3
 Raw Response: {
   "examName": "Advanced Placement Exams",
   "topics": [
     "AP Biology: Biological Systems Interactions"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following best describes the role of enzymes in biological systems?",
       "options": {
         "A": "Provide structural support to cell membranes",
         "B": "Act as catalysts to speed up chemical reactions",
         "C": "Store and transmit genetic information",
         "D": "Transport substances across cell membranes"
       },
       "correctOption": "B",
       "overview": "Enzymes play a crucial role in biological systems by acting as catalysts. This means they speed up chemical reactions without being consumed in the process. This is essential for the myriad of biochemical reactions that take place within living organisms to occur at rates sufficient for life processes."
     },
     {
       "questionNumber": 2,
       "question": "In the context of ecosystems, how do plants primarily contribute to the carbon cycle?",
       "options": {
         "A": "By releasing carbon dioxide through respiration",
         "B": "By consuming other organisms",
         "C": "By absorbing carbon dioxide during photosynthesis",
         "D": "By decomposing organic material"
       },
       "correctOption": "C",
       "overview": "Plants play a vital role in the carbon cycle primarily through the process of photosynthesis, where they absorb carbon dioxide from the atmosphere and use it, along with sunlight and water, to produce glucose and oxygen. This process not only contributes to the carbon cycle but also provides oxygen, which is essential for the respiration of most living organisms."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following best explains the importance of water's high specific heat capacity to living organisms?",
       "options": {
         "A": "It allows water to conduct electricity, which is vital for the nervous system.",
         "B": "It enables water to dissolve a wide range of substances, making it a versatile solvent.",
         "C": "It helps regulate climate by absorbing large amounts of heat with only small changes in temperature.",
         "D": "It contributes to the buoyancy of aquatic organisms."
       },
       "correctOption": "C",
       "overview": "Water's high specific heat capacity is crucial for living organisms because it allows water to absorb or release large amounts of heat with only minimal changes in its own temperature. This property helps regulate the temperature of environments, such as bodies of water and the overall climate, providing a stable environment for living organisms to thrive."
     }
   ]
 }
 
 //////ACT Exam
 Raw server response: {"topics":["English Grammar and Usage","Punctuation Rules","Sentence Structure","Organization of Ideas","Rhetorical Skills","Reading Comprehension","Literary Terms","Prose and Poetry Analysis","Data Representation in Science","Research Summaries in Science","Conflicting Viewpoints in Science","Algebra","Coordinate Geometry","Plane Geometry","Trigonometry","Word Problems","Probability","Statistics","Data Analysis","Reading Graphs and Tables","Problem Solving","Logical Reasoning","Test-Taking Strategies","Time Management","Essay Writing","Argument Analysis","Evidence Evaluation","Context Clues in Reading","Interpreting Experiments","Scientific Investigation","Understanding Scientific Studies","Mathematical Formulas","Arithmetic Operations","Properties of Integers","Rational Numbers","Percentages","Ratios and Proportions","Mean","Median","Mode","Range","Scientific Notation","Polynomials","Quadratic Equations","Linear Equations","Systems of Equations","Inequalities","Functions","Exponents and Radicals","Absolute Value","Sequences and Series","Mat"]}
 Starting fetchQuestionData for examName: ACT Exam with topics: ["Trigonometry"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=ACT%20Exam&topicValue=Trigonometry&numberValue=3
 Raw Response: {
   "examName": "ACT Exam",
   "topics": [
     "Trigonometry"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "What is the sine of 90 degrees?",
       "options": {
         "A": "0",
         "B": "1",
         "C": "0.5",
         "D": "√2/2"
       },
       "correctOption": "B",
       "overview": "The sine of 90 degrees is 1. This is a fundamental value in trigonometry, representing the maximum value the sine function can achieve."
     },
     {
       "questionNumber": 2,
       "question": "Which trigonometric function represents the ratio of the opposite side to the hypotenuse in a right-angled triangle?",
       "options": {
         "A": "Cosine",
         "B": "Sine",
         "C": "Tangent",
         "D": "Cotangent"
       },
       "correctOption": "B",
       "overview": "The sine function represents the ratio of the length of the side opposite the angle to the length of the hypotenuse in a right-angled triangle."
     },
     {
       "questionNumber": 3,
       "question": "What is the value of cos(0)?",
       "options": {
         "A": "0",
         "B": "1",
         "C": "0.5",
         "D": "√3/2"
       },
       "correctOption": "B",
       "overview": "The value of cos(0) is 1. This is because cosine represents the x-coordinate on the unit circle, and at 0 degrees, the point is at (1, 0)."
     }
   ]
 }
 
 ////////Graduate Management Admission Test
 Response HTTP Status code: 200
 Raw server response: {"topics":["Analytical Writing Assessment","Argument Analysis","Critical Reasoning","Logical Reasoning","Reading Comprehension","Sentence Correction","Integrated Reasoning","Multi-Source Reasoning","Table Analysis","Graphics Interpretation","Two-Part Analysis","Quantitative Reasoning","Problem Solving","Data Sufficiency","Algebra","Fractions","Decimals","Percentages","Number Properties","Exponents","Roots","Geometry","Coordinate Geometry","Permutation","Combination","Probability","Statistics","Ratio Proportions","Speed","Distance","Time","Work","Interest","Profit and Loss","Mensuration","Quadratic Equations","Linear Equations","Inequalities","Absolute Values","Functions","Graphs","Lines","Circles","Parabola","Ellipse","Hyperbola","Trigonometry","Set Theory","Sequences and Series","Complex Numbers","Arithmetic Mean","Geometric Mean","Median","Mode","Range","Standard Deviation","Variance","Counting Methods","Discrete Probability","Continuous Probability","Probability Distributions"]}
 Starting fetchQuestionData for examName: Graduate Management Admission Test with topics: ["Critical Reasoning"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Graduate%20Management%20Admission%20Test&topicValue=Critical%20Reasoning&numberValue=3
 Raw Response: {
   "examName": "Graduate Management Admission Test",
   "topics": [
     "Critical Reasoning"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "What is the main purpose of critical reasoning?",
       "options": {
         "A": "To evaluate arguments logically",
         "B": "To memorize facts",
         "C": "To understand numerical data",
         "D": "To write essays"
       },
       "correctOption": "A",
       "overview": "Critical reasoning is the process of evaluating arguments and reasoning in a logical manner. Its main purpose is not to memorize facts, understand numerical data, or write essays, but rather to assess the strength of arguments and the validity of the conclusions drawn from them."
     },
     {
       "questionNumber": 2,
       "question": "Which of the following is a common logical fallacy?",
       "options": {
         "A": "Ad hominem",
         "B": "Empirical evidence",
         "C": "Deductive reasoning",
         "D": "Inductive reasoning"
       },
       "correctOption": "A",
       "overview": "An ad hominem argument is a common logical fallacy that involves attacking the character or motive of a person making an argument rather than addressing the substance of the argument itself. Unlike empirical evidence, deductive reasoning, and inductive reasoning, which are components of logical analysis, ad hominem serves to undermine arguments through irrelevant personal attacks."
     },
     {
       "questionNumber": 3,
       "question": "What does it mean to 'strengthen' an argument in critical reasoning?",
       "options": {
         "A": "To increase the volume of the argument",
         "B": "To add more examples",
         "C": "To make the conclusion more likely to be true",
         "D": "To lengthen the argument"
       },
       "correctOption": "C",
       "overview": "In critical reasoning, to 'strengthen' an argument means to provide additional evidence or reasoning that makes the conclusion more likely to be true. This is not about increasing the volume, adding more examples for the sake of quantity, or lengthening the argument, but rather about enhancing the logical support for the argument's conclusion."
     }
   ]
 }
 
 ///////US Citizenship Test
 Response HTTP Status code: 200
 Raw server response: {"topics":["US Government Structure","The Constitution","The Bill of Rights","The Three Branches of Government","Executive Branch","Legislative Branch","Judicial Branch","The Federal System","The Declaration of Independence","The Founding Fathers","US Political History","US Historical Events","US Geography","US Symbols","US Holidays","US Presidents","US Vice Presidents","US Supreme Court Justices","US Congress","US Political Parties","The Electoral Process","US Military History","US Citizenship Rights and Responsibilities","US Immigration History","English Language Proficiency","Reading Comprehension","Writing Skills","US Economic System","US Cultural History","Native American History","African American History","Women's Rights Movement","Civil Rights Movement","World War I","World War II","The Cold War","The Vietnam War","The War on Terrorism","The Great Depression","The Civil War","The Revolutionary War","The Louisiana Purchase","The Gold Rush","The Space Race","The Industrial Revolution","The Internet Revolution","The Environmental Movement","The LGBT Rights Movement","The Labor Movement"]}
 Starting fetchQuestionData for examName: US Citizenship Test with topics: ["US Immigration History"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=US%20Citizenship%20Test&topicValue=US%20Immigration%20History&numberValue=3
 Raw Response: {
   "examName": "US Citizenship Test",
   "topics": [
     "US Immigration History"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "When did the first Europeans settle in what is now the United States?",
       "options": {
         "A": "1492",
         "B": "1607",
         "C": "1620",
         "D": "1776"
       },
       "correctOption": "B",
       "overview": "The first successful English settlement in what is now the United States was Jamestown, founded in 1607. While Christopher Columbus arrived in the Americas in 1492, and the Pilgrims landed in 1620, Jamestown is recognized as the first permanent English settlement."
     },
     {
       "questionNumber": 2,
       "question": "Which law first established restrictions on immigration to the United States?",
       "options": {
         "A": "The Naturalization Act of 1790",
         "B": "The Chinese Exclusion Act of 1882",
         "C": "The Immigration Act of 1924",
         "D": "The Immigration and Nationality Act of 1965"
       },
       "correctOption": "B",
       "overview": "The Chinese Exclusion Act of 1882 was the first significant law restricting immigration into the United States. It specifically prohibited all immigration of Chinese laborers. Prior acts, like the Naturalization Act of 1790, focused on citizenship rather than immigration itself."
     },
     {
       "questionNumber": 3,
       "question": "What significant immigration policy did the Immigration and Nationality Act of 1965 introduce?",
       "options": {
         "A": "It established quotas based on national origin.",
         "B": "It made English the official language for naturalization.",
         "C": "It abolished the national origins quota system.",
         "D": "It introduced a lottery system for immigration."
       },
       "correctOption": "C",
       "overview": "The Immigration and Nationality Act of 1965, also known as the Hart-Celler Act, abolished the national origins quota system that had structured America's immigration policy since the 1920s, replacing it with a preference system that focused on immigrants' skills and family relationships with citizens or U.S. residents."
     }
   ]
 }
 
 
 ////////
 Raw server response: {"topics":["Healthcare Industry Overview","Healthcare Finance Basics","Healthcare Revenue Cycle Management","Healthcare Insurance Basics","Healthcare Accounting","Healthcare Budgeting","Financial Analysis in Healthcare","Healthcare Financial Management","Healthcare Financial Reporting","Healthcare Economics","Healthcare Law and Regulations","Healthcare Strategic Planning","Healthcare Information Systems","Healthcare Risk Management","Healthcare Operations Management","Healthcare Investment Management","Healthcare Capital Financing","Healthcare Costing and Decision Making","Healthcare Auditing","Healthcare Compliance","Healthcare Quality and Performance Improvement","Healthcare Policy","Healthcare Data Analysis","Healthcare Financial Planning","Healthcare Organizational Behavior","Healthcare Marketing","Healthcare Ethics","Healthcare Human Resources Management","Patient Financial Services","Managed Care","Healthcare Taxation","Nonprofit Healthcare Organizations","For-profit Healthcare Organizations","Healthcare Mergers and Acquisitions","Healthcare Financial Forecasting","Healthcare Supply Chain Management","Healthcare Project Management","Healthcare Contract Management","Healthcare Reimbursement Models","Healthcare Fraud and Abuse","Healthcare Information Technology","Healthcare Innovation and Entrepreneurship","Healthcare Leadership and Governance","Healthcare Negotiation and Conflict Resolution","Healthcare Change Management"]}
 Starting fetchQuestionData for examName: Certified Healthcare Financial Professional with topics: ["Healthcare Organizational Behavior"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Certified%20Healthcare%20Financial%20Professional&topicValue=Healthcare%20Organizational%20Behavior&numberValue=3
 Raw Response: {
   "examName": "Certified Healthcare Financial Professional",
   "topics": [
     "Healthcare Organizational Behavior"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following best describes the term 'organizational behavior' within a healthcare setting?",
       "options": {
         "A": "The administrative tasks involved in running a healthcare facility",
         "B": "The study of how individuals and groups act within the organizations where they work",
         "C": "The financial management practices of healthcare institutions",
         "D": "The legal regulations governing healthcare facilities"
       },
       "correctOption": "B",
       "overview": "Organizational behavior is the study of how individuals and groups act within the organizations where they work. In healthcare, understanding organizational behavior is crucial for improving patient care, enhancing teamwork, and developing effective leadership."
     },
     {
       "questionNumber": 2,
       "question": "What role does leadership play in healthcare organizational behavior?",
       "options": {
         "A": "Leadership has no significant impact on organizational behavior.",
         "B": "Leadership primarily focuses on financial management.",
         "C": "Leadership influences organizational culture, employee satisfaction, and patient care.",
         "D": "Leadership is only relevant in administrative tasks."
       },
       "correctOption": "C",
       "overview": "In healthcare organizational behavior, leadership plays a crucial role in shaping organizational culture, enhancing employee satisfaction, and ultimately improving patient care. Effective leaders inspire, motivate, and guide individuals towards achieving the organization's goals."
     },
     {
       "questionNumber": 3,
       "question": "How does effective communication impact healthcare organizational behavior?",
       "options": {
         "A": "It has no significant impact.",
         "B": "It leads to increased patient satisfaction and safety.",
         "C": "It only affects the relationship between staff members.",
         "D": "It is only important for legal documentation."
       },
       "correctOption": "B",
       "overview": "Effective communication is vital in healthcare organizational behavior as it leads to increased patient satisfaction and safety. Clear communication among healthcare professionals ensures that patient care is coordinated, errors are minimized, and the healthcare team works efficiently towards common goals."
     }
   ]
 }
 
 /////////California Bar Exam
 Response HTTP Status code: 200
 Raw server response: {"topics":["Professional Responsibility and Ethics","Understanding the California Rules of Professional Conduct","Understanding the American Bar Association (ABA) Model Rules of Professional Conduct","Confidentiality of Information","Conflict of Interest","Competence","Legal Malpractice","Communication with Clients","Fees and Fee Agreements","Roles of the Lawyer","Unauthorized Practice of Law","Advertising and Solicitation","Civil Procedure","Understanding Jurisdiction and Venue","Understanding Pleadings and Motions","Understanding Pre-Trial Procedures","Understanding Trial Procedures","Understanding Post-Trial Procedures","Understanding Evidence","Understanding Discovery","Understanding Appeals","Criminal Law and Procedure","Understanding Crimes Against Persons","Understanding Crimes Against Property","Understanding Inchoate Crimes","Understanding Constitutional Protections for Defendants","Understanding Criminal Procedure Before Trial","Understanding Criminal Trial Procedure","Understanding Sentencing and Appeals","Contracts","Understanding Contract Formation","Understanding Contract Performance","Understanding Contract Breach","Understanding Contract Remedies","Torts","Understanding Intentional Torts","Understanding Negligence","Understanding Strict Liability","Understanding Defamation","Understanding Privacy"]}
 Starting fetchQuestionData for examName: California Bar Exam with topics: ["Understanding Crimes Against Property"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=California%20Bar%20Exam&topicValue=Understanding%20Crimes%20Against%20Property&numberValue=3
 Raw Response: {
   "examName": "California Bar Exam",
   "topics": [
     "Understanding Crimes Against Property"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is considered a crime against property?",
       "options": {
         "A": "Assault",
         "B": "Burglary",
         "C": "Kidnapping",
         "D": "Murder"
       },
       "correctOption": "B",
       "overview": "Crimes against property involve the theft or destruction of someone else's property. Among the options, burglary is a crime against property because it involves entering a building illegally with the intent to commit a crime, typically theft."
     },
     {
       "questionNumber": 2,
       "question": "What is required to prove the crime of arson?",
       "options": {
         "A": "The defendant's intention to harm a person",
         "B": "The defendant's accidental burning of their property",
         "C": "The deliberate setting of a fire to property",
         "D": "Proof of theft prior to the fire"
       },
       "correctOption": "C",
       "overview": "Arson requires the intentional setting of a fire to property. It is a crime against property that involves deliberately setting fire to buildings, wildland areas, or other property with the intent to cause damage."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following best defines larceny?",
       "options": {
         "A": "Unlawful taking of someone's personal property with the intent to keep it permanently",
         "B": "Entering a building illegally with intent to commit a crime",
         "C": "Taking a vehicle without the owner's consent",
         "D": "Damaging someone's property intentionally"
       },
       "correctOption": "A",
       "overview": "Larceny is defined as the unlawful taking and carrying away of someone else's personal property with the intent to deprive the rightful owner of it permanently. It is a specific type of theft and does not involve force or breaking into someone's property, distinguishing it from burglary and robbery."
     }
   ]
 }
 
 //////Medical College Admission Test
 Response HTTP Status code: 200
 Raw server response: {"topics":["Biology: Molecular Biology","Biology: Microbiology","Biology: Embryology","Biology: Evolution","Biology: Genetics","Biology: Biological Systems","Biology: Cell Structure and Function","Chemistry: General Chemistry","Chemistry: Organic Chemistry","Chemistry: Acid-Base Chemistry","Chemistry: Thermodynamics","Chemistry: Kinetics","Chemistry: Spectroscopy","Chemistry: Separation","Chemistry: Structure and Stereochemistry of Organic Compounds","Physics: Mechanics","Physics: Thermodynamics","Physics: Circuits","Physics: Optics and Light","Physics: Atomic and Nuclear Phenomena","Physics: Fluids and Gases","Biochemistry: Amino Acids and Proteins","Biochemistry: Metabolism","Biochemistry: Enzymes","Biochemistry: Molecular Genetics","Biochemistry: Lipid Metabolism","Biochemistry: Carbohydrate Metabolism","Psychology: Sensation and Perception","Psychology: Learning and Memory","Psychology: Life Span Development","Psychology: Social Psychology","Psychology:"]}
 Starting fetchQuestionData for examName: Medical Colledge Admission Test with topics: ["Biochemistry: Amino Acids and Proteins"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Medical%20Colledge%20Admission%20Test&topicValue=Biochemistry:%20Amino%20Acids%20and%20Proteins&numberValue=3
 Raw Response: {
   "examName": "Medical College Admission Test",
   "topics": [
     "Biochemistry",
     "Amino Acids and Proteins"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following amino acids is essential in the human diet?",
       "options": {
         "A": "Alanine",
         "B": "Valine",
         "C": "Glutamine",
         "D": "Asparagine"
       },
       "correctOption": "B",
       "overview": "Essential amino acids cannot be synthesized de novo by the organism (in this case, humans), and therefore must be supplied in the diet. Valine is one of the nine essential amino acids, making it a critical component of the human diet for protein synthesis and various metabolic functions."
     },
     {
       "questionNumber": 2,
       "question": "Which level of protein structure is determined by hydrogen bonding between the backbone components of the polypeptide chain?",
       "options": {
         "A": "Primary structure",
         "B": "Secondary structure",
         "C": "Tertiary structure",
         "D": "Quaternary structure"
       },
       "correctOption": "B",
       "overview": "The secondary structure of proteins is formed by hydrogen bonds between the backbone atoms in the polypeptide chain. This level of structure includes alpha-helices and beta-sheets, which are stabilized by hydrogen bonding patterns that do not involve the side chains of the amino acids."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following best describes the quaternary structure of a protein?",
       "options": {
         "A": "The sequence of amino acids in a protein",
         "B": "The alpha-helices and beta-sheets that are formed by hydrogen bonding",
         "C": "The overall 3D structure of a single polypeptide chain",
         "D": "The assembly of multiple polypeptide subunits into a functional protein complex"
       },
       "correctOption": "D",
       "overview": "The quaternary structure of a protein refers to the assembly of multiple polypeptide chains (subunits) into a larger functional complex. This level of structure is critical for the function of many proteins, including enzymes and structural proteins, allowing for intricate interactions and regulatory mechanisms."
     }
   ]
 }
 
 ///////Certified Public Accountant
 Raw server response: {"topics":["Auditing and Attestation","Understanding Auditing Process","Internal Controls and Risk Assessment","Performing Further Procedures and Obtaining Evidence","Forming Conclusions and Reporting","Business Environment and Concepts","Corporate Governance","Economic Concepts and Analysis","Financial Management","Information Technology","Operations Management","Financial Accounting and Reporting","Conceptual Framework","Standard-Setting and Financial Reporting","Select Financial Statement Accounts","Select Transactions","State and Local Governments","Regulation","Ethics","Professional and Legal Responsibilities","Federal Tax Process","Procedures and Law","Business Law","Federal Taxation of Property Transactions","Federal Taxation of Individuals","Federal Taxation of Entities"]}
 Raw Response: {
   "examName": "Certified Public Accountant",
   "topics": [
     "Select Financial Statement Accounts"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is considered an asset?",
       "options": {
         "A": "Accounts Payable",
         "B": "Cash",
         "C": "Dividends",
         "D": "Sales Revenue"
       },
       "correctOption": "B",
       "overview": "Assets are resources owned by a business that have economic value. Cash is an asset because it represents a resource that can be used to facilitate business operations and transactions. Accounts Payable is a liability, Dividends are distributions to shareholders, and Sales Revenue is an income statement account, not an asset."
     },
     {
       "questionNumber": 2,
       "question": "Which of the following accounts would appear on the income statement?",
       "options": {
         "A": "Inventory",
         "B": "Accounts Receivable",
         "C": "Sales Revenue",
         "D": "Buildings"
       },
       "correctOption": "C",
       "overview": "The income statement reports a company's financial performance over a specific accounting period. Sales Revenue is an income statement account that reflects the income earned from selling goods or services. Inventory and Buildings are considered assets, while Accounts Receivable is also an asset representing money owed to the company."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following is a liability?",
       "options": {
         "A": "Cash",
         "B": "Accounts Payable",
         "C": "Prepaid Insurance",
         "D": "Common Stock"
       },
       "correctOption": "B",
       "overview": "Liabilities are obligations of a company that arise during the course of its operations. Accounts Payable is a liability account that represents amounts the company owes to suppliers or vendors. Cash and Prepaid Insurance are assets, and Common Stock represents equity, not a liability."
     }
   ]
 }
 
 Raw Response: {
   "examName": "Bar Professional Training Course",
   "topics": [
     "Constitutional Law"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which principle asserts that the law should govern a nation, as opposed to being governed by decisions of individual government officials?",
       "options": {
         "A": "Rule of Law",
         "B": "Separation of Powers",
         "C": "Judicial Review",
         "D": "Parliamentary Sovereignty"
       },
       "correctOption": "A",
       "overview": "The Rule of Law is a fundamental principle in constitutional law that asserts the importance of law governing a nation rather than arbitrary decisions by individual government officials. It ensures that all individuals and authorities within the state, public and private, are bound by and entitled to the benefit of laws."
     },
     {
       "questionNumber": 2,
       "question": "Which of the following best describes the concept of Parliamentary Sovereignty?",
       "options": {
         "A": "The judiciary's ability to interpret the law",
         "B": "The division of powers among branches of government",
         "C": "The legislature's authority to make or unmake any law",
         "D": "The executive's power to enforce laws"
       },
       "correctOption": "C",
       "overview": "Parliamentary Sovereignty is a key principle in the UK's constitutional law, which means that Parliament has the supreme legal authority and can create or end any law. Generally, the courts cannot overrule its legislation and no Parliament can pass laws that future Parliaments cannot change."
     },
     {
       "questionNumber": 3,
       "question": "What does the Separation of Powers principle entail?",
       "options": {
         "A": "The independence of the judiciary from the other branches of government",
         "B": "The division of government responsibilities into distinct branches to limit any one branch from exercising the core functions of another",
         "C": "The ability of the judiciary to declare legislative acts unconstitutional",
         "D": "The concentration of power within the legislative branch"
       },
       "correctOption": "B",
       "overview": "The Separation of Powers is a doctrine of constitutional law under which the three branches of government (executive, legislative, and judicial) are kept separate. This is to prevent abuse of power and to provide for checks and balances within the government. Each branch has its own responsibilities, and its powers are distinct from those of the other branches."
     }
   ]
 }
 
 Raw Response: {
   "examName": "US Citizenship Test",
   "topics": [
     "The Articles of Confederation"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "What was the main weakness of the Articles of Confederation?",
       "options": {
         "A": "It gave too much power to the national government.",
         "B": "It did not provide a national currency.",
         "C": "It did not allow for a president.",
         "D": "It gave too little power to the national government."
       },
       "correctOption": "D",
       "overview": "The Articles of Confederation established the first governmental structure unifying the 13 colonies that had fought in the American Revolution. However, this document put too little power in the central government. Congress, under the Articles, was not strong enough to enforce laws or raise taxes, making it difficult to support a national defense or fund the government."
     },
     {
       "questionNumber": 2,
       "question": "Under the Articles of Confederation, how many states needed to agree in order to pass a new law?",
       "options": {
         "A": "7 out of 13",
         "B": "9 out of 13",
         "C": "11 out of 13",
         "D": "13 out of 13"
       },
       "correctOption": "B",
       "overview": "The Articles of Confederation required a supermajority for the passage of most types of legislation. Specifically, to pass a new law, 9 out of the 13 states had to agree. This high threshold made it difficult for Congress to take action on many issues."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following was a power that Congress had under the Articles of Confederation?",
       "options": {
         "A": "To regulate interstate commerce",
         "B": "To levy taxes",
         "C": "To declare war",
         "D": "To enforce laws"
       },
       "correctOption": "C",
       "overview": "Under the Articles of Confederation, Congress had the power to declare war. However, it lacked many other powers that would be considered essential for a strong central government, such as the power to levy taxes, regulate trade, or enforce laws. This limitation was a significant factor in the decision to draft the Constitution."
     }
   ]
 }

 SWIFT:
 Response HTTP Status code: 200
 Raw server response: {"topics":["Introduction to Swift Programming Language","Basic Syntax of Swift","Swift Variables and Constants","Swift Data Types","Swift Operators","Swift Control Flow","Swift Loops","Swift Functions","Swift Closures","Swift Enumerations","Swift Structures and Classes","Swift Properties","Swift Methods","Swift Subscripts","Swift Inheritance","Swift Initialization","Swift Deinitialization","Swift Optional Chaining","Swift Error Handling","Swift Type Casting","Swift Nested Types","Swift Extensions","Swift Protocols","Swift Generics","Swift Access Control","Swift Advanced Operators","Swift Memory Management","Swift Concurrency","Swift Collections: Arrays","Swift Collections: Sets","Swift Collections: Dictionaries","Swift String and Characters","Swift Error and Exception Handling","Swift Design Patterns","Swift Network Programming","Swift File Handling","Swift Regular Expressions","Swift JSON Parsing","Swift XML Parsing","Swift Working with Databases","Swift User Interface Design","Swift Testing and Debugging","Swift App Deployment","Swift for iOS Development","Swift for macOS Development","Swift for watch"]}
 ContentBuilder has created: 46 Topics
 
 SUPPLY CHAIN MGT
 {"topics":["Supply Chain Management Fundamentals","Supply Chain Strategy","Supply Chain Design","Supply Chain Planning","Supply Chain Execution","Supply Chain Improvement and Best Practices","Supply Chain Risk Management","Supply Chain Finance","Supply Chain Information Systems","Supply Chain Operations","Supply Chain Logistics","Inventory Management","Warehousing","Transportation Management","Demand Planning","Supply Chain Analytics","Supplier Relationship Management","Customer Relationship Management in Supply Chain","Lean Six Sigma in Supply Chain","Sustainable Supply Chain Management","Global Supply Chain Management","E-commerce in Supply Chain Management","Procurement and Sourcing Strategies","Enterprise Resource Planning (ERP)","Material Requirement Planning (MRP)","Distribution Resource Planning (DRP)","Supply Chain Performance Metrics","Supply Chain Compliance and Regulations","Supply Chain Project Management","Outsourcing Strategies in Supply Chain","Supply Chain Forecasting","Supply Chain Integration","Supplier Evaluation and Selection","Supply Chain Costing","Reverse Logistics","Cross-functional Strategy in Supply Chain","Supply Chain Modeling","Supply Chain Conflict Resolution","Supply Chain Negotiation","Supply Chain Leadership","Supply"]}
 
 ARCHITECT EXAM
 Response HTTP Status code: 200
 Raw server response: {"topics":["Understanding of Building Systems","Understanding of Structural Systems","Understanding of Mechanical Systems","Understanding of Electrical Systems","Understanding of Plumbing Systems","Understanding of Fire Protection Systems","Understanding of Vertical Transportation Systems","Understanding of Acoustics","Understanding of Building Materials and Assemblies","Understanding of Construction Cost Estimating","Understanding of Site Planning","Understanding of Site Design","Understanding of Zoning Regulations","Understanding of Building Codes","Understanding of Accessibility Regulations","Understanding of Sustainable Design Principles","Understanding of Building Lifecycle Management","Understanding of Architectural Programming","Understanding of Space Planning","Understanding of Design Concept Development","Understanding of Design Communication","Understanding of Architectural Drawing Conventions","Understanding of Building Information Modeling","Understanding of Project Management Principles","Understanding of Architectural Practice Management","Understanding of Contracts and Legal Issues","Understanding of Project Delivery Methods","Understanding of Professional Ethics","Understanding of Historic Preservation","Understanding of Urban Design Principles","Understanding of Landscape Design Principles","Understanding of Interior Design Principles","Understanding of Human Behavior and the Built Environment","Understanding of Environmental Systems,"]}
 ContentBuilder has created: 34 Topics
 
 :Certified Information Systems Security Professional Exam
 Response HTTP Status code: 200
 Raw server response: {"topics":["Security and Risk Management","Confidentiality","Integrity","Availability","Security Governance Principles","Compliance","Legal and Regulatory Issues","Professional Ethics","Security Policies","Standards","Procedures and Guidelines","Asset Security","Information and Asset Classification","Ownership","Protect Privacy","Appropriate Retention","Data Security Controls","Handling Requirements","Security Engineering","Engineering Processes using Secure Design Principles","Security Models Fundamental Concepts","Security Evaluation Models","Security Capabilities of Information Systems","Security Architectures","Designs and Solution Elements","Vulnerabilities of Security Architectures","Cryptography","Site and Facility Design Secure Principles","Physical Security","Communication and Network Security","Secure Network Architecture Design","Secure Network Components","Secure Communication Channels","Identity and Access Management","Physical and Logical Assets Control","Identification and Authentication of People and Devices","Identity as a Service","Third-Party Identity Services","Access Control Attacks","Identity and Access Provisioning Lifecycle","Security Assessment and Testing","Assessment and Test Strategies","Security Process Data","Security Control Testing","Test Outputs","Security Assessment and Test Techniques"]}
 ContentBuilder has created: 46 Topics
 
 Raw server response: {"topics":["Introduction to Ethical Hacking","Ethics and Legal Issues","Footprinting","Network Scanning","Enumeration","System Hacking","Trojans and Backdoors","Viruses and Worms","Sniffing","Social Engineering","Denial of Service","Session Hijacking","Hacking Web Servers","Web Application Vulnerabilities","Web-Based Password Cracking Techniques","SQL Injection","Hacking Wireless Networks","Physical Security","Linux Hacking","Evading IDS","Firewalls and Honeypots","Buffer Overflows","Cryptography","Penetration Testing","Cloud Computing and Ethical Hacking","IoT Hacking","Mobile Platform Attack Vectors","Mobile Device Management and Mobile Security","Wireless Network Threats","Wireless Network Security","Firewalls and IDS","Intrusion Detection Systems","Packet Sniffing and Spoofing","Network Traffic Analysis and Sniffing","VPN and Encryption","Password Cracking","Malware Threats","Email Hacking","File and Disk Encryption","Security Policies","Disaster Recovery","Incident Management"]}
 ContentBuilder has created: 42 Topics
 
 Raw server response: {"topics":["Understanding the English Legal System","Criminal Litigation","Civil Litigation","Law of Evidence","Professional Ethics","Advocacy","Alternative Dispute Resolution","Drafting Legal Documents","Legal Research","Opinion Writing","Conference Skills","Negotiation Skills","Legal Analysis","Contract Law","Tort Law","Property Law","Trusts Law","Public Law","EU Law","Human Rights Law","Company Law","Family Law","Employment Law","Intellectual Property Law","Immigration Law","Tax Law","Landlord and Tenant Law","Wills and Probate Law","Understanding Court Etiquette","Understanding Legal Proceedings","Legal History","Legal Theory","Legal Philosophy","Comparative Law","International Law","Maritime Law","Medical Law","Environmental Law","Financial Law","Insolvency Law","Criminal Justice","Criminal Procedure","Civil Procedure","Commercial Law","Consumer Law","Administrative Law","Constitutional Law","Equity and Trusts","Land Law","Jurisprudence","Legal Writing","Legal Drafting","Legal Negotiation","Legal Mediation","Legal Arbitration","Criminal"]}
 Starting fetchQuestionData for examName: Bar Professional Training Course with topics: ["Criminal Litigation", "Employment Law", "Alternative Dispute Resolution"]
 
 Number of Questions for Certified Six Sigma Green Belt Exam: 0
 Response HTTP Status code: 200
 Raw server response: {"topics":["Six Sigma Basics","Six Sigma Fundamentals","Six Sigma Methodologies","Lean Six Sigma Principles","Six Sigma Tools and Techniques","DMAIC (Define","Measure","Analyze","Improve","Control) Methodology","Roles and Responsibilities in Six Sigma","Six Sigma Project Management","Six Sigma Quality Management","Statistical Process Control","Process Mapping in Six Sigma","Value Stream Mapping","Cause and Effect Diagrams","Pareto Analysis","FMEA (Failure Modes and Effects Analysis)","Control Charts","Hypothesis Testing","Design of Experiments","Correlation and Regression Analysis","Data Collection Techniques","Measurement System Analysis","Process Capability Analysis","Risk Management in Six Sigma","Six Sigma Change Management","Six Sigma Team Dynamics","Six Sigma Communication Techniques","Six Sigma Customer Relations","Six Sigma and Business Strategy Alignment","Six Sigma Benchmarking","Six Sigma Cost Analysis","Six Sigma Performance Metrics","Six Sigma Process Improvement Techniques","Six Sigma Supply Chain Management","Six Sigma Training and Coaching Techniques","Six Sigma Certification and Accreditation Standards","Six Sigma"]}
 
 
 You are an expert multiple-choice question examiner.  Given an exam name, topic and number of questions, generate professional practice exam multi choice style questions. 

 Your question should efficiently test the depth of knowledge of the user as it relates to that topic. Please ensure that the questions are challenging, substantial and expressive, using real life scenarios, professional or otherwise where required to give the question more depth, context and relevance to the exam or the knowledge it seeks to test.
 MAKE QUESTIONS EXTEND MORE THAN A SINGLE LINE/SENTENCE.
 Multi choice Options
 Add multi choice Answers to your Questions NOT EXCEEDING A - D (Four Options) Make the options engaging and complex without being intuitive or easy to guess. 
 Answer: 
 Provide the correct answer among the options: A or B or C or D
 Overview: Your Role here is to EXTENSIVELY EDUCATE on the subject matter, Topic or Question relative to the correct answer in a bid to teach a User ALL they need to know about the Specific Question and Topic. Make your overview engaging, creative, expressive and professional ensuring to pass along the most important information regarding the question and or topic. 

 FOR EASY PARSING PLEASE RETURN with headers
 Question
 Options
 correctOption
 Overview

 DO NOT NUMBER THE QUESTIONS SINCE NUMBER IS ALREADY KNOWN  OUTPUT FORMAT AS FOLLOWS ADD A LINE OF SPACE
 BETWEEN QUESTIONS``

 */
