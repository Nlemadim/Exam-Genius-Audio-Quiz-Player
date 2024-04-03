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
    case isDonePlaying
    case isListening
    case isProcessing
    case errorResponse
    case awaitingResponse
    case hasResponded
    case idle
    case successfulResponse
    case isCorrectAnswer
    case isIncorrectAnswer
    case errorTranscription
    case successfulTranscription
    case isDownloading
    
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
        case .isDonePlaying:
            return "Has finished playing"
        case .isCorrectAnswer:
            return "Answer is correct"
        case .isIncorrectAnswer:
            return "Answer is incorrect"
        case .errorTranscription:
            return "Error transcribing response"
        case .successfulTranscription:
            return "Response Transcribed"
        case .isDownloading:
            return "Downloading"
        }
    }
}


//MARK: SERVER RESPONSE OBJECT (TOPICS REQUEST)
/** Response HTTP Status code: 200
 Raw server response: {"topics":["Constitutional Law","Constitutional Law - Bill of Rights","Constitutional Law - Separation of Powers","Constitutional Law - Federalism","Constitutional Law - Individual Rights","Criminal Law","Criminal Law - Crimes Against the Person","Criminal Law - Crimes Against Property","Criminal Law - Inchoate Crimes","Criminal Law - Defenses","Criminal Procedure","Criminal Procedure - Fourth Amendment","Criminal Procedure - Fifth Amendment","Criminal Procedure - Sixth Amendment","Real Property Law","Real Property Law - Land Ownership","Real Property Law - Landlord-Tenant Law","Real Property Law - Real Estate Transactions","Torts","Torts - Intentional Torts","Torts - Negligence","Torts - Strict Liability","Torts - Defamation","Torts - Privacy Torts","Evidence","Evidence - Relevancy","Evidence - Hearsay","Evidence - Privileges","Evidence - Presentation of Evidence","Civil Procedure","Civil Procedure - Jurisdiction","Civil Procedure - Pleadings","Civil Procedure - Pretrial Procedures,"]}
 
 AWS Certified Solutions Architect Exam
 Response HTTP Status code: 200
 Raw server response: {"topics":["Amazon Web Services (AWS) Overview","AWS Global Infrastructure","AWS Management Console","AWS CLI","AWS SDKs","Identity and Access Management (IAM)","Amazon Simple Storage Service (S3)","Amazon Glacier","Amazon Elastic Block Store (EBS)","Amazon Elastic File System (EFS)","Amazon EC2 Instances","Amazon EC2 Auto Scaling","Amazon Elastic Load Balancing","Amazon Virtual Private Cloud (VPC)","AWS Direct Connect","Amazon Route 53","AWS CloudFront","Amazon RDS","Amazon DynamoDB","Amazon ElastiCache","Amazon Redshift","Amazon Athena","Amazon QuickSight","Amazon EMR","AWS Glue","AWS Lambda","AWS Step Functions","Amazon SNS","Amazon SQS","Amazon SWF","Amazon MQ","AWS Application Integration","AWS CloudFormation","AWS CloudTrail","Amazon CloudWatch","AWS Config","AWS OpsWorks","AWS Service Catalog","AWS Systems Manager","AWS Trusted Advisor","AWS Well-Architected Framework","AWS Security Best Practices","AWS Compliance"]}
 
 Certified Information Systems Auditor Exam
 Response HTTP Status code: 200
 Raw server response: {"topics":["Information Systems Auditing Process","Developing and Implementing an Audit Strategy","Conducting an IS Audit","Documenting Audit Results","Audit Standards","Guidelines and Codes of Ethics","Risk Analysis","Risk Management","Control Self-Assessment","Business Process Evaluation and Risk Management","Types of Controls","Business Continuity Planning","Disaster Recovery Planning","Systems Infrastructure Control","Data Encryption","Network Security","Firewall and VPN Management","Intrusion Detection and Prevention","Business Continuity and Disaster Recovery","Data Backup Strategies","Data Recovery Strategies","IT Governance","IT Strategy and Policy","IT Management and Leadership","IT Service Delivery and Support","IT Infrastructure","Hardware","and Software","Information Security Management","Network Architecture and Design","Physical and Environmental Security","System Access Control","Data Classification Standards","Privacy Principles","Incident Management","IT Service Level Management","IT Operations","IT Project Management","IT Quality Assurance","Software Development","Acquisition","and Maintenance","System Development Life Cycle (SDLC)","Business Application Systems","Business Information Systems","Enterprise Architecture","Data"]}
 
 Response HTTP Status code: 200
 Raw server response: {"topics":["1. AP English Literature and Composition: Understanding of Prose","2. AP English Literature and Composition: Understanding of Poetry","3. AP English Literature and Composition: Literary Analysis","4. AP English Literature and Composition: Writing Skills","5. AP English Language and Composition: Rhetorical Analysis","6. AP English Language and Composition: Argumentation","7. AP English Language and Composition: Synthesis of Information","8. AP English Language and Composition: Grammar and Usage","9. AP Calculus AB: Limits and Continuity","10. AP Calculus AB: Derivatives","11. AP Calculus AB: Integrals","12. AP Calculus AB: Polynomial Approximations and Series","13. AP Calculus BC: Parametric","Polar","and Vector Functions","14. AP Calculus BC: Infinite Sequences and Series","15. AP Calculus BC: Differential Equations","16. AP"]}
 ContentBuilder has created: 18 Topics

 
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
 
 ////////SAT
 Response HTTP Status code: 200
 Raw server response: {"topics":["Reading Comprehension","Understanding of Main Ideas in Texts","Identifying Supporting Details in Texts","Drawing Inferences from Texts","Understanding Vocabulary in Context","Understanding of Author's Purpose","Understanding of Rhetorical Devices","Understanding of Text Structures","Understanding of Tone and Style in Texts","Understanding of Textual Evidence","Critical Reading Skills","Analyzing Arguments in Texts","Understanding of Synonyms and Antonyms","Understanding of Word Roots","Prefixes and Suffixes","Understanding of Figurative Language","Understanding of Connotation and Denotation","Understanding of Sentence Completion","Writing and Language Test","Identifying Sentence Errors","Improving Sentences and Paragraphs","Understanding Grammar and Usage","Understanding of Punctuation","Understanding of Sentence Structure","Understanding of Conventions of Standard English","Understanding of Verb Tense","Understanding of Subject-Verb Agreement","Understanding of Pronoun Agreement","Understanding of Parallel Structure","Understanding of Modifier Placement","Understanding of Idiomatic Expressions","Understanding of Wordiness and"]}
 Starting fetchQuestionData for examName: SAT Exam with topics: ["Understanding of Wordiness and"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=SAT%20Exam&topicValue=Understanding%20of%20Wordiness%20and&numberValue=3
 Raw Response: {
   "examName": "SAT Exam",
   "topics": [
     "Understanding of Wordiness"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following sentences is the least wordy and most effective?",
       "options": {
         "A": "The reason for the failure of the project was primarily because of unforeseen weather conditions.",
         "B": "Unforeseen weather conditions were primarily the reason why the project failed.",
         "C": "The project failed primarily because of unforeseen weather conditions.",
         "D": "Primarily, it was unforeseen weather conditions that were the reason for the project's failure."
       },
       "correctOption": "C",
       "overview": "Option C is the most direct and concise way to convey the information, making it the least wordy. It avoids unnecessary phrases like 'the reason for' and 'was because,' which are common sources of wordiness."
     },
 {
   "questionNumber": 1,
   "question": "What is the primary purpose of the SAT exam?",
   "options": {
     "A": "To assess students' readiness for college",
     "B": "To evaluate teachers' effectiveness",
     "C": "For high school graduation requirements",
     "D": "To measure intelligence"
   },
   "correctOption": "A",
   "overview": "The SAT exam is designed primarily to assess a high school student's readiness for college. Colleges often use SAT scores as a part of the admissions process."
 },
 {
   "questionNumber": 2,
   "question": "Which section is not a part of the SAT exam?",
   "options": {
     "A": "Mathematics",
     "B": "Critical Reading",
     "C": "Science",
     "D": "Writing and Language"
   },
   "correctOption": "C",
   "overview": "The SAT exam includes sections on Mathematics, Critical Reading, and Writing and Language. There is no specific Science section, although some science-related questions can be found within the other sections."
 },
 {
   "questionNumber": 3,
   "question": "What is the time duration of the SAT exam without the essay?",
   "options": {
     "A": "2 hours 45 minutes",
     "B": "3 hours",
     "C": "3 hours 45 minutes",
     "D": "4 hours"
   },
   "correctOption": "B",
   "overview": "The SAT exam lasts 3 hours without the essay section. If the essay section is included, the total time increases to 3 hours and 50 minutes."
 }
     {
       "questionNumber": 2,
       "question": "Identify the sentence that eliminates unnecessary wordiness.",
       "options": {
         "A": "She made adjustments to the plan in order to reduce the time that was necessary to complete it.",
         "B": "She adjusted the plan to reduce the necessary time to complete it.",
         "C": "In order to complete it, she made necessary adjustments to the plan to reduce the time.",
         "D": "She adjusted the plan to reduce the completion time."
       },
       "correctOption": "D",
       "overview": "Option D is the most concise choice, effectively communicating the same idea without the redundancy found in the other options. It eliminates phrases like 'in order to' and 'that was necessary,' which contribute to wordiness."
     },
     {
       "questionNumber": 3,
       "question": "Which sentence best avoids unnecessary words?",
       "options": {
         "A": "At this point in time, we need to make a decision as to whether or not we will proceed.",
         "B": "We need to decide whether we will proceed or not.",
         "C": "We need to make a decision about proceeding.",
         "D": "Now, we must decide whether to proceed."
       },
       "correctOption": "D",
       "overview": "Option D is the most straightforward and concise, avoiding the wordiness present in the other choices. Phrases like 'at this point in time' and 'as to whether or not' are unnecessarily verbose."
     }
   ]
 }
 
 /////// GOOGLECLOUD
 Response HTTP Status code: 200
 Raw server response: {"topics":["Google Cloud Platform Fundamentals","Understanding Google Cloud Architecture","Understanding Google Cloud Services","Google Cloud Storage","Google Cloud Databases","Google Cloud Networking","Google Compute Engine","Google App Engine","Google Kubernetes Engine","Google Cloud Functions","Google Cloud Operations","Google Cloud Security","Google Cloud IAM","Google Cloud Billing and Pricing","Google Cloud SDK","Google Cloud APIs","Google Cloud Console","Google Cloud CLI","Google Cloud Machine Learning Services","Google Cloud Data Analytics Services","Google Cloud IoT Services","Google Cloud Bigtable","Google Cloud Spanner","Google Cloud Pub/Sub","Google Cloud Firestore","Google Cloud Memorystore","Google Cloud Filestore","Google Cloud Load Balancing","Google Cloud DNS","Google Cloud VPC","Google Cloud Interconnect","Google Cloud VPN","Google Cloud Armor","Google Cloud Secret Manager","Google Cloud Security Command Center","Google Cloud Identity-Aware Proxy","Google Cloud Key Management Service","Google Cloud Audit Logs","Google Cloud Data Loss Prevention API","Google Cloud Deployment Manager","Google Cloud Cloud Build","Google"]}
 Starting fetchQuestionData for examName: Google Cloud Certified Exam with topics: ["Google Cloud Databases"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Google%20Cloud%20Certified%20Exam&topicValue=Google%20Cloud%20Databases&numberValue=3
 Raw Response: {
   "examName": "Google Cloud Certified Exam",
   "topics": [
     "Google Cloud Databases"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which Google Cloud database service is fully managed and scales automatically to meet application demand?",
       "options": {
         "A": "Cloud SQL",
         "B": "Cloud Spanner",
         "C": "Firestore",
         "D": "Bigtable"
       },
       "correctOption": "B",
       "overview": "Cloud Spanner is a fully managed relational database with unlimited scale, strong consistency, and up to 99.999% availability. It is designed to scale automatically to meet the demand of your applications."
     },
     {
       "questionNumber": 2,
       "question": "What type of database is Cloud Bigtable best suited for?",
       "options": {
         "A": "Relational database workloads",
         "B": "NoSQL database workloads for web applications",
         "C": "Analytical workloads and time-series data",
         "D": "Mobile and gaming applications"
       },
       "correctOption": "C",
       "overview": "Cloud Bigtable is ideal for storing large amounts of single-keyed data with very low latency. It is especially good for analytical workloads and time-series data."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following is a key feature of Firestore?",
       "options": {
         "A": "SQL-like queries",
         "B": "Automatic multi-region replication",
         "C": "Support for hierarchical data structures",
         "D": "All of the above"
       },
       "correctOption": "D",
       "overview": "Firestore is a highly scalable NoSQL database for mobile, web, and server development. It features SQL-like queries, automatic multi-region replication, and support for hierarchical data structures."
     }
   ]
 }
 
 ////////LINUX
 Response HTTP Status code: 200
 Raw server response: {"topics":["Linux System Architecture","Filesystem Hierarchy Standard","Linux Installation and Package Management","GNU and Unix Commands","Devices","Linux Filesystems","Filesystem Hierarchy Standard","Shells","Scripting and Data Management","User Interfaces and Desktops","Administrative Tasks","Essential System Services","Networking Fundamentals","Security","Linux Kernel","Boot","Initialization","Shutdown and Runlevels","Linux Package Management","Hostnames","Network Interfaces","Network Services","Domain Name Service","SSH (Secure Shell)","TCP Wrappers","Linux Firewalls","NTP Server Configuration","System Log Configuration","Linux File Sharing","Samba Server Configuration","NFS Server Configuration","HTTP Server Configuration","Squid Proxy Server Configuration","Postfix Mail Transfer Agent","Sendmail Mail Transfer Agent","IMAP and POP3 Servers","Postgresql Database Configuration","MySQL Database Configuration","DNS Server Configuration","File Sharing with NFS","Configuring Samba","Apache and HTTP Services","Linux Web Hosting","DHCP and Pxe Boot","Linux VPNs","Linux Firewalls Using"]}
 Starting fetchQuestionData for examName: Linux Professional Institute Certification with topics: ["SSH (Secure Shell)"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Linux%20Professional%20Institute%20Certification&topicValue=SSH%20(Secure%20Shell)&numberValue=3
 Raw Response: {
   "examName": "Linux Professional Institute Certification",
   "topics": ["SSH (Secure Shell)"],
   "questions": [
 {
   "questionNumber": 1,
   "question": "Which command is used to create a GPG key pair?",
   "options": {
     "A": "gpg --gen-key",
     "B": "gpg --create-key",
     "C": "openssl genpkey",
     "D": "ssh-keygen"
   },
   "correctOption": "A",
   "overview": "The command 'gpg --gen-key' is used to create a GPG (GNU Privacy Guard) key pair, which is essential for encrypting and decrypting data to ensure its security. GPG is a widely used tool for securing communication and data storage on Linux systems."
 },
 {
   "questionNumber": 2,
   "question": "What is the purpose of the 'ssh-keygen' command?",
   "options": {
     "A": "To generate a GPG key pair",
     "B": "To generate an SSH key pair",
     "C": "To encrypt a file with a password",
     "D": "To sign a document digitally"
   },
   "correctOption": "B",
   "overview": "The 'ssh-keygen' command is used to generate a pair of SSH keys, which are used for secure shell access to remote machines without needing a password. SSH keys provide a more secure way of logging into a server with SSH than using a password alone."
 },
 {
   "questionNumber": 3,
   "question": "Which option with the 'gpg' command is used to encrypt a file?",
   "options": {
     "A": "--export",
     "B": "--decrypt",
     "C": "--encrypt",
     "D": "--list-keys"
   },
   "correctOption": "C",
   "overview": "The '--encrypt' option with the 'gpg' command is used to encrypt files. Encryption is a method of securing data by converting it into a code to prevent unauthorized access. GPG provides a robust framework for encrypting and decrypting data, ensuring its confidentiality."
 }
     {
       "questionNumber": 1,
       "question": "Which port is the default for SSH connections?",
       "options": {
         "A": "21",
         "B": "22",
         "C": "80",
         "D": "443"
       },
       "correctOption": "B",
       "overview": "SSH (Secure Shell) connections typically use port 22 by default. This port is designated for encrypted communication and is used for secure logins, file transfers, and more."
     },
     {
       "questionNumber": 2,
       "question": "Which command can be used to generate SSH keys?",
       "options": {
         "A": "ssh-keygen",
         "B": "ssh-copy-id",
         "C": "ssh-agent",
         "D": "ssh-add"
       },
       "correctOption": "A",
       "overview": "The 'ssh-keygen' command is used to generate SSH keys. It creates a public/private key pair for secure SSH authentication."
     },
     {
       "questionNumber": 3,
       "question": "What is the main advantage of using SSH keys over passwords?",
       "options": {
         "A": "Easier to remember",
         "B": "No need for usernames",
         "C": "Increased security",
         "D": "Faster connection speeds"
       },
       "correctOption": "C",
       "overview": "The main advantage of using SSH keys over passwords is increased security. SSH keys provide a more secure method of logging into a server with SSH than using a password alone. With SSH keys, a user can log into a server without having to remember or enter their password."
     }
   ]
 }

 ////////Certified Cloud Security Professional
 Response HTTP Status code: 200
 Raw server response: {"topics":["Cloud Computing Concepts","Cloud Reference Architecture","Cloud Computing Security Challenges","Cloud Service Models (IaaS","PaaS","SaaS)","Cloud Deployment Models (Public","Private","Hybrid","Community)","Cloud Data Security","Cloud Platform & Infrastructure Security","Cloud Application Security","Cloud Security Operations","Legal","Risk and Compliance","Cloud Governance","Cloud Data Lifecycle","Cloud Data Storage Architectures","Cloud Data Security Controls","Cloud Data Discovery","Data Rights Management","Storage & Data Security in Cloud","Data Backup and Recovery","Cloud Infrastructure Components","Cloud Risk Assessment","Cloud Audit Processes","Cloud Security Policies & Procedures","Identity & Access Management","User Identity Verification Methods","Identity Federation Protocols","Single Sign-On & Federation","Access Control Models in Cloud","Identity Provisioning","Cloud Network Security","Network Security Architecture","Cloud Network Security Controls","Virtualization Basics","Virtualization Security","Cloud Resource Management","Incident Response in Cloud","Forensics in Cloud","Business Continuity & Disaster Recovery","Legal Requirements & Unique Risks in Cloud"]}
 Starting fetchQuestionData for examName: Certified Cloud Security Professional with topics: ["Cloud Resource Management"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Certified%20Cloud%20Security%20Professional&topicValue=Cloud%20Resource%20Management&numberValue=3
 Raw Response: {
   "examName": "Certified Cloud Security Professional",
   "topics": [
     "Cloud Resource Management"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is a key benefit of cloud resource tagging?",
       "options": {
         "A": "Increases the complexity of cloud architecture",
         "B": "Improves the ability to manage and allocate costs",
         "C": "Decreases the visibility of resources",
         "D": "Limits the scalability of cloud resources"
       },
       "correctOption": "B",
       "overview": "Tagging resources in the cloud allows organizations to assign metadata to cloud resources. This metadata can be used for various purposes, including cost allocation, management, and governance. By improving the ability to manage and allocate costs, organizations can gain better insights into their spending and usage patterns, leading to more efficient resource utilization and cost savings."
     },
     {
       "questionNumber": 2,
       "question": "What is the primary purpose of implementing Cloud Access Security Brokers (CASBs)?",
       "options": {
         "A": "To provide a physical security layer for cloud data centers",
         "B": "To act as intermediaries between users and cloud service providers",
         "C": "To replace traditional network firewalls",
         "D": "To increase the operational complexity of cloud services"
       },
       "correctOption": "B",
       "overview": "Cloud Access Security Brokers (CASBs) are security policy enforcement points that sit between cloud service consumers and cloud service providers. The primary purpose of CASBs is to provide visibility into cloud application usage, enforce security policies, and protect against threats. They act as intermediaries to ensure that the organization's security policies are consistently applied across all cloud services, helping to maintain security and compliance."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following strategies is MOST effective in ensuring data security in a multi-cloud environment?",
       "options": {
         "A": "Using a single cloud service provider for all data storage needs",
         "B": "Relying solely on the security measures provided by cloud service providers",
         "C": "Implementing a centralized identity and access management (IAM) system",
         "D": "Storing all sensitive data on-premises to avoid cloud risks"
       },
       "correctOption": "C",
       "overview": "In a multi-cloud environment, where an organization uses multiple cloud service providers, ensuring data security becomes complex due to the differing security models and controls across providers. Implementing a centralized identity and access management (IAM) system is the most effective strategy. This approach allows organizations to manage user identities and permissions consistently across all cloud services, reducing the risk of unauthorized access and ensuring that security policies are uniformly applied."
     }
   ]
 }
 
 ////////Barista Certification
 Response HTTP Status code: 200
 Raw server response: {"topics":["Coffee History","Coffee Bean Varieties","Coffee Cultivation and Harvesting","Coffee Processing Methods","Coffee Roasting Techniques","Understanding Coffee Grind Sizes","Coffee Cupping and Tasting","Espresso Basics","Espresso Machine Operation","Espresso Machine Maintenance","Milk Steaming and Frothing","Latte Art Techniques","Brew Methods and Techniques","Cold Brew and Iced Coffee Techniques","Coffee Brewing Water Temperature","Coffee to Water Ratio","Coffee Extraction Principles","Coffee Pairing with Food","Customer Service Skills","Cash Handling and Register Operation","Health and Safety Standards in Coffee Shops","Coffee Shop Equipment Use and Maintenance","Coffee Shop Management","Coffee Shop Marketing and Promotion","Specialty Coffee Industry Trends","Coffee Shop Menu Design","Coffee Shop Layout and Workflow","Understanding Coffee Sustainability Issues","Ethical Sourcing of Coffee","Coffee Shop Business Plan Development","Barista Vocabulary and Terminology","Seasonal Coffee Drink Recipes","Non-Dairy Milk Options for Coffee","Nutritional Information of Coffee Drinks","Dealing with Customer Complaints in Coffee Shops,"]}
 Starting fetchQuestionData for examName: Barista Certification with topics: ["Coffee Roasting Techniques"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Barista%20Certification&topicValue=Coffee%20Roasting%20Techniques&numberValue=3

 Raw Response: {
   "examName": "Barista Certification",
   "topics": [
     "Coffee Roasting Techniques"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "What does the term 'first crack' refer to in coffee roasting?",
       "options": {
         "A": "The initial phase of roasting where beans absorb heat",
         "B": "The point at which coffee beans begin to expand and crack",
         "C": "The final stage of roasting before cooling begins",
         "D": "The initial sorting process before roasting"
       },
       "correctOption": "B",
       "overview": "The 'first crack' in coffee roasting refers to a critical point where the coffee beans begin to expand and crack open due to the heat. This marks the transition from the drying phase to the actual roasting phase, where the beans start developing their characteristic flavors and aromas."
     },
     {
       "questionNumber": 2,
       "question": "Which roasting level is characterized by a shiny, dark surface on the beans due to oil?",
       "options": {
         "A": "Light roast",
         "B": "Medium roast",
         "C": "Medium-dark roast",
         "D": "Dark roast"
       },
       "correctOption": "D",
       "overview": "Dark roast coffee beans are characterized by a shiny, dark surface, which is a result of the oils within the beans emerging due to the high temperatures experienced during the roasting process. This level of roasting brings out a pronounced bitterness and reduces the acidity of the coffee."
     },
     {
       "questionNumber": 3,
       "question": "What is the main purpose of the cooling process immediately after coffee beans are roasted?",
       "options": {
         "A": "To prepare the beans for immediate packaging",
         "B": "To enhance the beans' natural flavors",
         "C": "To stop the roasting process and prevent over-roasting",
         "D": "To reduce the beans' moisture content further"
       },
       "correctOption": "C",
       "overview": "The main purpose of the cooling process immediately after coffee beans are roasted is to stop the roasting process and prevent the beans from over-roasting. This is crucial for preserving the desired flavor profile and ensuring the quality of the coffee."
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
 
 
 //////Architect Registration Exam
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
 
 
 ////////Certified Six Sigma Green Belt Exam
 Raw server response: {"topics":["Six Sigma Fundamentals","Definition of Six Sigma","History of Six Sigma","Six Sigma Methodologies","Lean Six Sigma","Six Sigma vs Lean","DMAIC Methodology","Define phase in DMAIC","Measure phase in DMAIC","Analyze phase in DMAIC","Improve phase in DMAIC","Control phase in DMAIC","DMADV Methodology","Define phase in DMADV","Measure phase in DMADV","Analyze phase in DMADV","Design phase in DMADV","Verify phase in DMADV","DPMO and Sigma Levels","Understanding of Variation","Role of Green Belt in Six Sigma","Six Sigma Project Selection","Project Charter in Six Sigma","Voice of Customer (VOC)","Critical To Quality (CTQ)","Quality Function Deployment (QFD)","Process Mapping","SIPOC Diagram","Value Stream Mapping","Cause and Effect Diagram","Pareto Analysis","Control Charts","Statistical Process Control","Measurement System Analysis","Capability Analysis","Hypothesis Testing","Correlation and Regression Analysis","Design of"]}
 Starting fetchQuestionData for examName: Certified Six Sigma Green Belt Exam with topics: ["Six Sigma Methodologies"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Certified%20Six%20Sigma%20Green%20Belt%20Exam&topicValue=Six%20Sigma%20Methodologies&numberValue=3
 Raw Response: {
   "examName": "Certified Six Sigma Green Belt Exam",
   "topics": [
     "Six Sigma Methodologies"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is a primary objective of Six Sigma?",
       "options": {
         "A": "Increasing team morale",
         "B": "Reducing process variation",
         "C": "Expanding market share",
         "D": "Decreasing employee turnover"
       },
       "correctOption": "B",
       "overview": "The primary objective of Six Sigma is to reduce process variation and improve quality by applying a data-driven approach. This methodology aims at minimizing defects and improving processes in manufacturing, services, and other industries."
     },
     {
       "questionNumber": 2,
       "question": "In the DMAIC methodology of Six Sigma, what does the 'M' stand for?",
       "options": {
         "A": "Management",
         "B": "Measure",
         "C": "Modify",
         "D": "Maintain"
       },
       "correctOption": "B",
       "overview": "In the DMAIC (Define, Measure, Analyze, Improve, Control) methodology of Six Sigma, 'M' stands for Measure. This phase focuses on measuring the current process to collect relevant data for further analysis."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following tools is commonly used in the Analyze phase of DMAIC?",
       "options": {
         "A": "Pareto Chart",
         "B": "Flowchart",
         "C": "SIPOC Diagram",
         "D": "Check Sheet"
       },
       "correctOption": "A",
       "overview": "A Pareto Chart is commonly used in the Analyze phase of DMAIC to identify and prioritize problems or defects in a process. It is a visual tool that helps teams focus on the most significant issues based on the 80/20 rule."
     },
 {
   "questionNumber": 1,
   "question": "What does DFSS stand for in the context of Six Sigma?",
   "options": {
     "A": "Design for Six Sigma",
     "B": "Define for System Success",
     "C": "Design for System Solutions",
     "D": "Define for Six Sigma"
   },
   "correctOption": "A",
   "overview": "DFSS stands for Design for Six Sigma. It is a methodology aimed at designing products, services, and processes that meet customer needs and expectations from the very beginning, by incorporating Six Sigma principles from the earliest stages of design."
 },
 {
   "questionNumber": 2,
   "question": "Which of the following is NOT a phase in the DFSS (Design for Six Sigma) methodology?",
   "options": {
     "A": "Analyze",
     "B": "Define",
     "C": "Verify",
     "D": "Optimize"
   },
   "correctOption": "D",
   "overview": "The DFSS (Design for Six Sigma) methodology typically includes phases such as Define, Measure, Analyze, Design, and Verify (DMADV). 'Optimize' is not traditionally listed as a phase in the DFSS methodology, which focuses on understanding customer needs and ensuring the design meets these needs before implementation."
 },
 {
   "questionNumber": 3,
   "question": "Which DFSS methodology phase focuses on identifying and prioritizing customer needs and requirements?",
   "options": {
     "A": "Measure",
     "B": "Analyze",
     "C": "Define",
     "D": "Design"
   },
   "correctOption": "C",
   "overview": "In the DFSS (Design for Six Sigma) methodology, the 'Define' phase focuses on identifying the project goals and customer needs and requirements. It sets the foundation for the project by clearly outlining what needs to be achieved to ensure customer satisfaction."
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
 
 //////////Certified Cloud Security Professional
 Raw server response: {"topics":["Cloud Computing Concepts","Cloud Reference Architecture","Cloud Computing Security Challenges","Cloud Data Security","Cloud Platform & Infrastructure Security","Cloud Application Security","Cloud Security Operations","Legal & Compliance Issues in Cloud Computing","Cloud Service Models (IaaS","PaaS","SaaS)","Cloud Deployment Models (Private","Public","Hybrid","Community)","Cloud Security Architecture","Cloud Data Life Cycle","Cloud Data Storage Architectures","Data Security & Encryption","Cloud Infrastructure Components","Virtualization in Cloud","Container Security","Cloud Network Security","Identity and Access Management in Cloud","Physical Security for Cloud Infrastructure","Incident Response in Cloud","Disaster Recovery & Business Continuity in Cloud","Security Assessment and Testing in Cloud","Security in Cloud Software Development Life Cycle","Cloud Service Level Agreement","Cloud Security Policies and Procedures","Risk Management in Cloud","Cloud Security Standards and Certifications","Ethical and Privacy Considerations in Cloud","Cloud Audit and Assurance","Secure Cloud Migration","Cloud Cryptography","Cloud Security Threats and Countermeasures","Cloud Security Best Practices"]}
 Raw Response: {
   "examName": "Certified Cloud Security Professional",
   "topics": ["Secure Cloud Migration"],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is the MOST critical factor to ensure the security of data during a cloud migration?",
       "options": {
         "A": "Selecting a cloud service provider with the lowest cost.",
         "B": "Ensuring proper data encryption both at rest and in transit.",
         "C": "Migrating all data at once to reduce the migration timeline.",
         "D": "Choosing a cloud service provider in the same country."
       },
       "correctOption": "B",
       "overview": "Ensuring proper data encryption both at rest and in transit is crucial during cloud migration to prevent unauthorized access and ensure data confidentiality. This protects the data as it moves to the cloud and while it is stored within the cloud environment."
     },
     {
       "questionNumber": 2,
       "question": "What is the PRIMARY benefit of using a multi-cloud strategy for cloud migration?",
       "options": {
         "A": "It ensures data is encrypted.",
         "B": "It reduces the dependency on a single cloud service provider.",
         "C": "It automatically complies with all regulatory requirements.",
         "D": "It guarantees zero downtime."
       },
       "correctOption": "B",
       "overview": "A multi-cloud strategy reduces dependency on a single cloud service provider, offering benefits such as improved reliability, risk management, and potentially better cost efficiency. It allows organizations to leverage the best services of different providers and avoid vendor lock-in."
     },
     {
       "questionNumber": 3,
       "question": "Which activity is MOST important during the initial phase of a secure cloud migration?",
       "options": {
         "A": "Selecting the cloud service model (IaaS, PaaS, SaaS).",
         "B": "Defining clear roles and responsibilities.",
         "C": "Performing a comprehensive security risk assessment.",
         "D": "Establishing a direct connection to the cloud provider."
       },
       "correctOption": "C",
       "overview": "Performing a comprehensive security risk assessment is crucial in the initial phase of cloud migration. It helps identify potential security risks and vulnerabilities that could impact the migrated data and applications, allowing for the development of appropriate mitigation strategies."
     },
 {
   "questionNumber": 1,
   "question": "Which legislation primarily deals with the enhancement of electronic communications privacy, and also protects against unauthorized access of cloud storage?",
   "options": {
     "A": "Sarbanes-Oxley Act",
     "B": "Federal Information Security Management Act (FISMA)",
     "C": "Electronic Communications Privacy Act (ECPA)",
     "D": "General Data Protection Regulation (GDPR)"
   },
   "correctOption": "C",
   "overview": "The Electronic Communications Privacy Act (ECPA) was enacted to extend government restrictions on wire taps from telephone calls to include transmissions of electronic data by computer. It also protects against unauthorized access of cloud storage, making it critical legislation in the context of cloud computing and privacy."
 },
 {
   "questionNumber": 2,
   "question": "Which of the following best describes the responsibility of cloud service providers in relation to data protection under GDPR?",
   "options": {
     "A": "Data controllers only",
     "B": "Data processors only",
     "C": "Both data controllers and data processors",
     "D": "Neither data controllers nor data processors"
   },
   "correctOption": "C",
   "overview": "Under the General Data Protection Regulation (GDPR), cloud service providers can act as both data controllers and data processors. This depends on the specific services and data handling practices. They have responsibilities under GDPR to ensure personal data is processed lawfully, transparently, and securely."
 },
 {
   "questionNumber": 3,
   "question": "What principle of cloud computing legal issues emphasizes the importance of ensuring that cloud-based applications and services meet local and international legal requirements?",
   "options": {
     "A": "Jurisdiction",
     "B": "Data sovereignty",
     "C": "Compliance",
     "D": "Privacy"
   },
   "correctOption": "C",
   "overview": "The principle of 'Compliance' in cloud computing legal issues emphasizes the need for cloud-based applications and services to adhere to both local and international legal and regulatory requirements. This is crucial to avoid legal penalties and ensure data protection and privacy standards are met."
 },
 {
   "questionNumber": 1,
   "question": "Which of the following is NOT a cloud data protection principle?",
   "options": {
     "A": "Data Encryption",
     "B": "Data Localization",
     "C": "Data Availability",
     "D": "Data Obfuscation"
   },
   "correctOption": "C",
   "overview": "Data Availability is a principle of data security focused on ensuring that data is accessible when needed by authorized users, but it is not specifically a data protection technique aimed at safeguarding data from unauthorized access or alterations. Data protection principles such as Data Encryption, Data Localization, and Data Obfuscation are designed to protect data from unauthorized access and ensure its confidentiality and integrity."
 },
 {
   "questionNumber": 2,
   "question": "What is the primary purpose of using encryption in cloud data security?",
   "options": {
     "A": "To enhance the performance of cloud services",
     "B": "To ensure data integrity",
     "C": "To prevent unauthorized data access",
     "D": "To increase data storage capacity"
   },
   "correctOption": "C",
   "overview": "The primary purpose of using encryption in cloud data security is to prevent unauthorized data access. Encryption transforms readable data into an unreadable format, which can only be converted back to its original form with the correct decryption key, thereby ensuring that even if the data is intercepted or accessed by unauthorized individuals, it remains unintelligible and secure."
 },
 {
   "questionNumber": 3,
   "question": "Which of the following best describes the concept of data localization in cloud computing?",
   "options": {
     "A": "Storing data in multiple locations to ensure redundancy",
     "B": "Restricting the physical location of data storage to comply with legal requirements",
     "C": "Using local encryption methods for data security",
     "D": "Localizing the user interface of cloud services for different regions"
   },
   "correctOption": "B",
   "overview": "Data localization in cloud computing refers to the practice of restricting the physical location of data storage to comply with legal requirements. This often involves storing data within a particular jurisdiction to adhere to the laws and regulations of that region, which may dictate that certain types of data must not leave the geographical boundaries of the country."
 },
 {
   "questionNumber": 1,
   "question": "Which of the following is a characteristic of a community cloud model?",
   "options": {
     "A": "It is owned and operated by a single organization.",
     "B": "It supports multiple organizations sharing computing resources.",
     "C": "It is dedicated to the public and offers the highest level of scalability.",
     "D": "It is a composition of two or more distinct cloud infrastructures."
   },
   "correctOption": "B",
   "overview": "A community cloud model is designed to allow multiple organizations to share computing resources. Unlike the public cloud, which is open to any user, the community cloud serves a specific group of users with common interests or requirements. This model provides a balance between the scalability of the public cloud and the control and security of a private cloud."
 },
 {
   "questionNumber": 2,
   "question": "What is a primary benefit of using a community cloud model for organizations with similar regulatory compliance requirements?",
   "options": {
     "A": "Decreased security and privacy concerns",
     "B": "Increased computational power",
     "C": "Cost reduction through shared resources",
     "D": "Unlimited storage capacity"
   },
   "correctOption": "C",
   "overview": "One of the primary benefits of using a community cloud model for organizations with similar regulatory compliance requirements is cost reduction through shared resources. By pooling resources, such as storage and processing capabilities, organizations can achieve economies of scale, leading to lower costs compared to using a private cloud or individual public cloud services. This model also facilitates compliance with specific regulations, as all participating entities face similar legal and regulatory frameworks."
 },
 {
   "questionNumber": 3,
   "question": "In the context of cloud security, what advantage does a community cloud offer over a public cloud?",
   "options": {
     "A": "It offers unlimited resources.",
     "B": "It provides a higher level of security and privacy.",
     "C": "It is more cost-effective for individual users.",
     "D": "It offers a wider range of services."
   },
   "correctOption": "B",
   "overview": "A community cloud offers a higher level of security and privacy compared to a public cloud. This is because it serves a specific group of users rather than the general public, allowing for more controlled access and shared security policies. Organizations within a community cloud can collaborate on security standards and protocols, ensuring that the infrastructure meets their specific security and privacy requirements."
 },
 {
   "questionNumber": 1,
   "question": "Which layer of cloud computing architecture is directly used by end-users?",
   "options": {
     "A": "Infrastructure as a Service (IaaS)",
     "B": "Platform as a Service (PaaS)",
     "C": "Software as a Service (SaaS)",
     "D": "Network as a Service (NaaS)"
   },
   "correctOption": "C",
   "overview": "Software as a Service (SaaS) is the layer of cloud computing architecture that is directly used by end-users. It provides access to application software and databases. Cloud providers manage the infrastructure and platforms that run the applications."
 },
 {
   "questionNumber": 2,
   "question": "In cloud reference architecture, what does the 'control layer' primarily manage?",
   "options": {
     "A": "Physical hardware resources",
     "B": "User access and identity",
     "C": "Data encryption and security",
     "D": "Deployment of services and applications"
   },
   "correctOption": "B",
   "overview": "In cloud reference architecture, the 'control layer' primarily manages user access and identity. It ensures that only authorized users can access certain resources and services, playing a crucial role in cloud security."
 },
 {
   "questionNumber": 3,
   "question": "Which of the following is NOT a characteristic of cloud computing?",
   "options": {
     "A": "On-demand self-service",
     "B": "Broad network access",
     "C": "Limited scalability",
     "D": "Resource pooling"
   },
   "correctOption": "C",
   "overview": "Limited scalability is NOT a characteristic of cloud computing. In contrast, one of the defining characteristics of cloud computing is rapid elasticity or scalability, which allows systems to easily scale up or down according to demand."
 }
 
   ]
 }
 
 
 
 /////////
 Raw Response: {
   "examName": "Certified Cloud Security Professional",
   "topics": [
     "Cloud Security",
     "Ethical Hacking"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is NOT a common cloud computing service model?",
       "options": {
         "A": "Infrastructure as a Service (IaaS)",
         "B": "Platform as a Service (PaaS)",
         "C": "Software as a Service (SaaS)",
         "D": "Data as a Service (DaaS)"
       },
       "correctOption": "D",
       "overview": "The three common cloud computing service models are Infrastructure as a Service (IaaS), Platform as a Service (PaaS), and Software as a Service (SaaS). Data as a Service (DaaS) is not typically classified among the foundational cloud service models."
     },
     {
       "questionNumber": 2,
       "question": "In ethical hacking, what is the primary purpose of penetration testing?",
       "options": {
         "A": "To steal data from competitors",
         "B": "To identify and exploit vulnerabilities in a system",
         "C": "To perform an audit of the system's user accounts",
         "D": "To repair vulnerabilities in a system"
       },
       "correctOption": "B",
       "overview": "The primary purpose of penetration testing in ethical hacking is to identify and exploit vulnerabilities in a system. This helps in understanding the weaknesses of the system and in improving its security posture, not to steal data or repair the vulnerabilities directly."
     },
     {
       "questionNumber": 3,
       "question": "Which principle of cloud security involves ensuring that data is only accessible by authorized users?",
       "options": {
         "A": "Data Integrity",
         "B": "Data Confidentiality",
         "C": "Data Availability",
         "D": "Data Redundancy"
       },
       "correctOption": "B",
       "overview": "Data Confidentiality is a principle of cloud security that involves ensuring that data is only accessible by authorized users. It is crucial for protecting sensitive information from unauthorized access and breaches."
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
