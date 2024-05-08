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

enum WordProcessorV2: String {
    case A, B, C, D, Invalid

    static func processWords(from transcript: String, comparedWords: [String] = []) -> String {
        let lowercasedTranscript = transcript.lowercased()

        // Check for predefined simple matches first
        switch lowercasedTranscript {
            
        case "a", "eh", "ay", "hey", "ea", "hay", "aye", "option A", "option eh", "option ay", "option hey", "option aye":
            return WordProcessor.A.rawValue
            
        case "b", "be", "bee", "beat", "bei", "bead", "bay", "bye", "buh", "option B", "option be", "option bee", "option bei", "option bay":
            return WordProcessor.B.rawValue
            
        case "c", "see", "sea", "si", "cee", "seed", "option C", "option see", "option si", "option seed":
            return WordProcessor.C.rawValue
            
        case "d", "dee", "the", "di", "dey", "they", "option D", "option dee", "option the", "option dey":
            return WordProcessor.D.rawValue
            
        default:
            // If no predefined matches, check dynamically provided words
            let dynamicResult = processDynamicWords(transcript: lowercasedTranscript, comparedWords: comparedWords)
            return dynamicResult == WordProcessorV2.Invalid.rawValue ? "Invalid Response" : dynamicResult
        }
    }

    static private func processDynamicWords(transcript: String, comparedWords: [String]) -> String {
        let normalizedTranscript = transcript.lowercased()
        for (index, word) in comparedWords.enumerated() {
            let normalizedWord = word.lowercased()
            // Consider partial matches and similarity check
            if normalizedTranscript.contains(normalizedWord) && normalizedTranscript.similarityRatio(to: normalizedWord) > 0.75 {
                // Correctly cast index to UInt32 before addition
                if let scalarValue = UnicodeScalar("A".unicodeScalars.first!.value + UInt32(index)) {
                    if let matchedOption = WordProcessorV2(rawValue: String(describing: scalarValue)) {
                        return matchedOption.rawValue
                    }
                }       
            }
        }
        
        return WordProcessorV2.Invalid.rawValue // Return "Invalid" if no matches are found
    }

}

enum InteractionState {
    case startedQuiz
    case endedQuiz
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
    case finishedDownloading
    case pausedPlayback
    case resumingPlayback
    case nowPlayingCorrection
    case isDonePlayingCorrection
    case playingFeedbackMessage
    case donePlayingFeedbackMessage
    case reviewing
    case doneReviewing
    case playingErrorMessage
    case donePlayingErrorMessage
    
    
    var status: String {
        switch self {
        case .isNowPlaying:
            return "Now Playing"
        case .isListening:
            return "Listening"
        case .errorResponse:
            return "Error Response"
        case .hasResponded:
            return "Recieved Response"
        case .idle:
            return "Ready"
        case .isProcessing:
            return "Processing"
        case .awaitingResponse:
            return "Awaiting Response"
        case .successfulResponse:
            return "Successfully Response"
        case .isDonePlaying:
            return "Finished Playing"
        case .isCorrectAnswer:
            return "Answer is correct"
        case .isIncorrectAnswer:
            return "Answer is incorrect"
        case .errorTranscription:
            return "Error Transcribing Response"
        case .successfulTranscription:
            return "Response Transcribed"
        case .isDownloading:
            return "Downloading"
        case .finishedDownloading:
            return "Finished Downloading"
        case .pausedPlayback:
            return "Paused Quiz"
        case .resumingPlayback:
            return "Resuming Quiz"
        case .nowPlayingCorrection:
            return "Playing Correction"
        case .isDonePlayingCorrection:
            return "Done Playing Correction"
        case .playingFeedbackMessage:
            return "Playing feedback message"
        case .donePlayingFeedbackMessage:
            return "Done playing feedback message"
        case .startedQuiz:
            return "Quiz in Progress"
        case .endedQuiz:
            return "Quiz Complete"
            
        case .reviewing:
            return "Reviewing"
            
        case .doneReviewing:
            return "Review complete"
            
        case .playingErrorMessage:
            return "playing error message"
            
        case .donePlayingErrorMessage:
            return "Done playing error message"
        }
    }
}

enum Score {
    case zero
    case ten
    case twenty
    case thirty
    case forty
    case fifty
    case sixty
    case seventy
    case eighty
    case ninety
    case perfect
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
 
 ///////
 Raw server response: {"topics":["English Grammar and Usage","Punctuation in English","Sentence Structure","Rhetorical Skills","Strategy in English","Organization in English","Style in English","Reading Comprehension","Literal Comprehension","Inferential Comprehension","Main Idea and Details","Relationships","Integration of Knowledge and Ideas","Key Ideas and Details","Craft and Structure","Integration of Knowledge and Ideas","Vocabulary Interpretation","Mathematics","Pre-Algebra","Elementary Algebra","Intermediate Algebra","Coordinate Geometry","Plane Geometry","Trigonometry","Data Analysis","Statistics","Probability","Science Reasoning","Interpretation of Data","Scientific Investigation","Evaluation of Models","Inferences","Experimental Results","Scientific Knowledge","Understanding Complex Systems","Writing Skills","Essay Planning","Essay Writing","Argumentative Writing","Persuasive Writing","Analytical Writing","Time Management","Test-Taking Strategies","Problem-Solving Skills","Critical Thinking Skills"]}
 Starting fetchQuestionData for examName: ACT with topics: ["Literal Comprehension"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=ACT&topicValue=Literal%20Comprehension&numberValue=3
 Raw Response: {
   "examName": "ACT",
   "topics": [
    
   ],
   "questions": [
    
   ]
 }
 ////////////USContitution
 {"topics":["The Preamble to the Constitution","The Articles of the Constitution","The Amendments to the Constitution","The Bill of Rights","The Federal System","The Legislative Branch","The Executive Branch","The Judicial Branch","The Checks and Balances System","The Supremacy Clause","The Elastic Clause","The Due Process Clause","The Equal Protection Clause","The Establishment Clause","The Free Exercise Clause","The Commerce Clause","The Necessary and Proper Clause","The Full Faith and Credit Clause","The Privileges and Immunities Clause","The Ex Post Facto Laws","The Habeas Corpus","The Impeachment Process","The Presidential Veto Power","The Appointment Power of the President","The War Powers of Congress","The Treaty Making Power of the President","The Power of Judicial Review","The Role of the Supreme Court","The Interpretation of the Constitution","The Process of Amending the Constitution","The Concept of Federalism","The Separation of Powers","The Rights and Liberties Guaranteed by the Constitution","The Structure of the"]}
 
 Response HTTP Status code: 200
 Raw server response: {"topics":["The Preamble to the Constitution","The Articles of the Constitution","The Amendments to the Constitution","The Bill of Rights","The Constitutional Convention","The Ratification of the Constitution","The Federalist Papers","The Anti-Federalist Papers","The Supremacy Clause","The Necessary and Proper Clause","The Commerce Clause","The Full Faith and Credit Clause","The Privileges and Immunities Clause","The Due Process Clause","The Equal Protection Clause","The Establishment Clause","The Free Exercise Clause","The Free Speech Clause","The Right to Bear Arms","The Right to a Fair Trial","The Right to Privacy","The Separation of Powers","The System of Checks and Balances","The Federal System of Government","The Role of the Executive Branch","The Role of the Legislative Branch","The Role of the Judicial Branch","The Process of Amending the Constitution","The Role of the Supreme Court in Interpreting the Constitution","Landmark Supreme Court Decisions","The Constitution and Civil Liberties","The Constitution and Civil Rights"]}
 Starting fetchQuestionData for examName: The United States Constitution with topics: ["The Role of the Judicial Branch"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=The%20United%20States%20Constitution&topicValue=The%20Role%20of%20the%20Judicial%20Branch&numberValue=3
 
 /////////
 Response HTTP Status code: 200
 Raw server response: {"topics":["AP Biology: Cellular Processes","AP Biology: Evolution","AP Biology: Organ Systems","AP Biology: Genetics","AP Biology: Ecological Systems","AP Biology: Biotechnology","AP Biology: Biochemistry","AP Biology: Energy Transfer,"]}
 Starting fetchQuestionData for examName: Advanced Placement Exams with topics: ["AP Biology: Organ Systems"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Advanced%20Placement%20Exams&topicValue=AP%20Biology:%20Organ%20Systems&numberValue=3
 Raw Response: {
   "examName": "Advanced Placement Exams",
   "topics": [
     "AP Biology: Organ Systems"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which organ system is primarily responsible for transporting nutrients, wastes, and gases throughout the body?",
       "options": {
         "A": "Digestive System",
         "B": "Circulatory System",
         "C": "Respiratory System",
         "D": "Excretory System"
       },
       "correctOption": "B",
       "overview": "The circulatory system is primarily responsible for transporting nutrients, wastes, and gases throughout the body. It consists of the heart, blood, and blood vessels. This system works in conjunction with the respiratory system to transport oxygen to tissues and remove carbon dioxide."
     },
     {
       "questionNumber": 2,
       "question": "Which of the following is a function of the skeletal system?",
       "options": {
         "A": "Producing movement",
         "B": "Transporting oxygen",
         "C": "Protecting internal organs",
         "D": "Absorbing nutrients"
       },
       "correctOption": "C",
       "overview": "The skeletal system's functions include providing support, leverage, protection for internal organs, and the storage of minerals (such as calcium). Protecting internal organs is a primary function, as bones such as the skull and rib cage safeguard the brain and heart/lungs, respectively."
     },
     {
       "questionNumber": 3,
       "question": "What is the main role of the respiratory system?",
       "options": {
         "A": "To remove waste from the bloodstream",
         "B": "To break down food into nutrients",
         "C": "To supply the body with oxygen and remove carbon dioxide",
         "D": "To fight infection"
       },
       "correctOption": "C",
       "overview": "The main role of the respiratory system is to supply the body with oxygen and remove carbon dioxide. This is achieved through the process of breathing: inhaling oxygen-rich air and exhaling air filled with carbon dioxide. The respiratory system includes organs such as the lungs and airways."
     }
   ]
 }
 
 Raw Response: {
   "examName": "Advanced Placement Exams",
   "topics": [
     "AP Biology: Cellular Processes"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "What is the primary role of the chloroplasts in plant cells?",
       "options": {
         "A": "Protein synthesis",
         "B": "Cellular respiration",
         "C": "Photosynthesis",
         "D": "DNA replication"
       },
       "correctOption": "C",
       "overview": "Chloroplasts are organelles found in plant cells and eukaryotic algae that conduct photosynthesis. They capture light energy to synthesize organic compounds such as glucose from carbon dioxide and water. This process is critical for the energy flow in the biosphere."
     },
     {
       "questionNumber": 2,
       "question": "Which of the following processes occurs in the mitochondria?",
       "options": {
         "A": "Photosynthesis",
         "B": "Protein synthesis",
         "C": "Cellular respiration",
         "D": "Lipid synthesis"
       },
       "correctOption": "C",
       "overview": "The mitochondria, often referred to as the powerhouse of the cell, are where cellular respiration occurs. This process converts biochemical energy from nutrients into adenosine triphosphate (ATP), and releases waste products."
     },
     {
       "questionNumber": 3,
       "question": "What is the role of ribosomes in a cell?",
       "options": {
         "A": "Energy production",
         "B": "Protein synthesis",
         "C": "Lipid metabolism",
         "D": "Detoxification"
       },
       "correctOption": "B",
       "overview": "Ribosomes are complex molecular machines found within all living cells that perform biological protein synthesis (translation). They link amino acids together in the order specified by messenger RNA (mRNA) molecules."
     }
   ]
 }
 
 Raw Response: {
   "examName": "Advanced Placement Exams",
   "topics": [
     "Context"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "In the context of European history, what was the main impact of the Treaty of Westphalia (1648)?",
       "options": {
         "A": "It initiated the start of the European Union.",
         "B": "It marked the end of religious wars in Europe.",
         "C": "It established the principle of balance of power.",
         "D": "It ended the Thirty Years' War and established the sovereignty of nation-states."
       },
       "correctOption": "D",
       "overview": "The Treaty of Westphalia, signed in 1648, ended the Thirty Years' War in the Holy Roman Empire and the Eighty Years' War between Spain and the Dutch Republic. It was significant for establishing the sovereignty of nation-states over their territory, a principle that shaped international relations and the concept of statehood thereafter."
     },
     {
       "questionNumber": 2,
       "question": "How did the Industrial Revolution alter the context of society in the 19th century?",
       "options": {
         "A": "It led to the decline of agricultural societies.",
         "B": "It caused a significant decrease in urban populations.",
         "C": "It introduced mass production and significantly changed social structures.",
         "D": "It diminished the importance of trade unions."
       },
       "correctOption": "C",
       "overview": "The Industrial Revolution, which began in the late 18th century and continued into the 19th, fundamentally changed society by introducing mass production, leading to the growth of cities as people moved from rural areas to urban centers for work, altering family structures, and creating new social classes. It marked the transition from agrarian economies to industrialized societies."
     },
     {
       "questionNumber": 3,
       "question": "What role did the context of Cold War tensions play in the Cuban Missile Crisis of 1962?",
       "options": {
         "A": "It led to the immediate start of World War III.",
         "B": "It was a peripheral factor with little influence on the crisis.",
         "C": "It escalated the crisis to a near-nuclear conflict between the US and the USSR.",
         "D": "It resulted in the strengthening of the United Nations."
       },
       "correctOption": "C",
       "overview": "The Cuban Missile Crisis was a direct result of the Cold War tensions between the United States and the Soviet Union. The discovery of Soviet nuclear missiles in Cuba in 1962 escalated these tensions to a near-nuclear conflict, with both sides on high alert. The crisis was eventually resolved through diplomatic negotiations, but it remains one of the closest instances the world has come to a full-scale nuclear war."
     }
   ]
 }
 
 
 //////////TOFEL
 Response HTTP Status code: 200
 Raw server response: {"topics":["Reading Comprehension","Understanding Main Ideas in Reading","Identifying Details in Reading","Understanding Authors' Intent in Reading","Understanding Vocabulary in Context","Reading to Find Information","Reading to Learn","Reading to Understand Rhetorical Function","Text Structure in Reading","Listening Comprehension","Understanding Main Ideas in Listening","Identifying Details in Listening","Understanding Speakers' Attitude in Listening","Understanding Vocabulary in Context in Listening","Listening to Understand Function","Speaking","Independent Speaking Tasks","Integrated Speaking Tasks","Pronunciation in Speaking","Grammar in Speaking","Vocabulary in Speaking","Fluency in Speaking","Writing","Independent Writing Tasks","Integrated Writing Tasks","Grammar in Writing","Vocabulary in Writing","Organization in Writing","Synthesis and Summary in Writing","Argumentation in Writing","Spelling and Punctuation in Writing","English Grammar Rules","Verb Tenses","Noun Usage","Pronoun Usage","Adjective and Adverb Usage","Prepositions and Conjunctions","Sentence Structure","English Vocabulary","Common English Phrases","Id"]}
 Starting fetchQuestionData for examName: Test of English as a Foreign Language with topics: ["Pronunciation in Speaking"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Test%20of%20English%20as%20a%20Foreign%20Language&topicValue=Pronunciation%20in%20Speaking&numberValue=3
 Raw Response: {
   "examName": "Test of English as a Foreign Language",
   "topics": [
     "Pronunciation in Speaking"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following words is pronounced with a silent 'k'?",
       "options": {
         "A": "Know",
         "B": "Pronounce",
         "C": "Speak",
         "D": "Talk"
       },
       "correctOption": "A",
       "overview": "In English, the letter 'k' is often silent when it precedes an 'n' at the beginning of a word, as in 'know'. This rule helps distinguish pronunciation patterns in English, aiding in the understanding of spoken language nuances."
     },
     {
       "questionNumber": 2,
       "question": "What is the stress pattern for the word 'pronunciation'?",
       "options": {
         "A": "PRO-nun-ci-a-tion",
         "B": "pro-NUN-ci-a-tion",
         "C": "pro-nun-CI-a-tion",
         "D": "pro-nun-ci-A-tion"
       },
       "correctOption": "B",
       "overview": "The word 'pronunciation' is stressed on the third syllable from the beginning, making 'pro-NUN-ci-a-tion' the correct stress pattern. Understanding stress patterns is crucial for clear and accurate English pronunciation."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following vowel sounds is considered a 'long' vowel sound?",
       "options": {
         "A": "/ɪ/ as in 'bit'",
         "B": "/eɪ/ as in 'bate'",
         "C": "/ʊ/ as in 'book'",
         "D": "/ʌ/ as in 'but'"
       },
       "correctOption": "B",
       "overview": "Long vowel sounds are those in which the vowel sound is pronounced similarly to its name in the alphabet. The '/eɪ/' sound in 'bate' is an example of a long vowel sound, contrasting with short vowel sounds that have a more compressed pronunciation."
     }
   ]
 }
 
 Raw Response: {
   "examName": "Test of English as a Foreign Language",
   "topics": [
     "Understanding Conversations"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "What is the primary purpose of initiating a conversation?",
       "options": {
         "A": "To argue a point",
         "B": "To exchange information",
         "C": "To entertain the listener",
         "D": "To fill a silence"
       },
       "correctOption": "B",
       "overview": "Initiating a conversation primarily aims to exchange information between participants. While conversations can also entertain, argue points, or fill silence, the fundamental goal is the exchange of ideas, thoughts, or information."
     },
     {
       "questionNumber": 2,
       "question": "In a conversation, what does it mean when someone is 'active listening'?",
       "options": {
         "A": "The person is preparing what to say next.",
         "B": "The person is distracted by other thoughts.",
         "C": "The person is fully focused on the speaker and their message.",
         "D": "The person is waiting for their turn to speak without listening."
       },
       "correctOption": "C",
       "overview": "Active listening involves being fully engaged and focused on what the speaker is saying, understanding their message, and responding thoughtfully. It's a key component of effective communication, indicating that the listener is genuinely interested in the speaker's words."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following best describes 'feedback' in the context of a conversation?",
       "options": {
         "A": "A formal evaluation of the conversation after it has ended",
         "B": "Verbal and non-verbal responses during the conversation",
         "C": "The final conclusion or agreement reached in a conversation",
         "D": "A detailed analysis of what was said in the conversation"
       },
       "correctOption": "B",
       "overview": "Feedback in a conversation consists of verbal and non-verbal responses that participants give each other during the exchange. This can include nods, expressions, comments, and questions that show understanding, agreement, or the need for clarification. Feedback helps to maintain the flow of communication and ensures that the conversation is productive."
     }
   ]
 }
 
 Raw Response: {
   "examName": "Test of English as a Foreign Language",
   "topics": [
     "Reading"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "What is the primary purpose of the passage?",
       "options": {
         "A": "To outline the history of a scientific discovery",
         "B": "To argue a position on a social issue",
         "C": "To describe the characteristics of a literary genre",
         "D": "To explain the process involved in a natural phenomenon"
       },
       "correctOption": "A",
       "overview": "The primary purpose of a passage is often to inform the reader about a particular subject. In this case, outlining the history of a scientific discovery provides a comprehensive overview of how that discovery came to be, including the context, the key figures involved, and its impact."
     },
     {
       "questionNumber": 2,
       "question": "According to the passage, what effect does 'X' have on 'Y'?",
       "options": {
         "A": "It significantly improves Y's efficiency",
         "B": "It causes a gradual decline in Y's effectiveness",
         "C": "It has no noticeable impact on Y",
         "D": "It initially boosts Y but later leads to its deterioration"
       },
       "correctOption": "B",
       "overview": "Understanding cause and effect is crucial in reading comprehension. This question tests the ability to analyze the relationship between two elements ('X' and 'Y') within the text. According to the passage, 'X' causes a gradual decline in 'Y's effectiveness, highlighting the importance of evaluating impacts in a given scenario."
     },
     {
       "questionNumber": 3,
       "question": "The author mentions 'Z' in the passage as an example of which of the following?",
       "options": {
         "A": "A successful adaptation to environmental changes",
         "B": "A common misconception about a historical event",
         "C": "An innovative approach to solving a technical problem",
         "D": "A controversial theory in the scientific community"
       },
       "correctOption": "C",
       "overview": "Authors often use examples to clarify or support their arguments. In this case, 'Z' is mentioned as an innovative approach to solving a technical problem, demonstrating how examples can effectively illustrate complex ideas or solutions in a way that is accessible to the reader."
     }
   ]
 }
 
 
 /////////
 Response HTTP Status code: 200
 Raw server response: {"topics":["AP Biology: Cellular Processes","AP Biology: Evolution","AP Biology: Interactions","AP Biology: Energy Transfer","AP Biology: Genetics","AP Biology: Information Transfer,"]}
 Starting fetchQuestionData for examName: Advanced Placement Exams with topics: ["AP Biology: Cellular Processes"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Advanced%20Placement%20Exams&topicValue=AP%20Biology:%20Cellular%20Processes&numberValue=3
 Raw Response: {
   "examName": "Advanced Placement Exams",
   "topics": [
     "AP Biology: Cellular Processes"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following best describes the role of the mitochondria?",
       "options": {
         "A": "Protein synthesis",
         "B": "Photosynthesis",
         "C": "Cellular respiration",
         "D": "DNA replication"
       },
       "correctOption": "C",
       "overview": "Mitochondria are known as the powerhouses of the cell because they convert oxygen and nutrients into adenosine triphosphate (ATP), which powers cellular activities. This process, known as cellular respiration, is crucial for energy production in eukaryotic cells."
     },
     {
       "questionNumber": 2,
       "question": "What is the primary function of ribosomes in a cell?",
       "options": {
         "A": "Energy production",
         "B": "Protein synthesis",
         "C": "Lipid synthesis",
         "D": "Detoxifying chemicals"
       },
       "correctOption": "B",
       "overview": "Ribosomes play a critical role in a cell by synthesizing proteins. They translate messenger RNA (mRNA) into polypeptide chains, which are then folded into functional proteins. This process is essential for the growth and repair of cells."
     },
     {
       "questionNumber": 3,
       "question": "Which process occurs in the chloroplasts?",
       "options": {
         "A": "Cellular respiration",
         "B": "Protein synthesis",
         "C": "Photosynthesis",
         "D": "DNA replication"
       },
       "correctOption": "C",
       "overview": "Chloroplasts are the site of photosynthesis in plant and algae cells. This process converts light energy, water, and carbon dioxide into glucose (a sugar) and oxygen. This is fundamental for producing the energy and organic materials needed for plant growth and oxygen for the planet."
     }
   ]
 }
 /////////MCATS
 Building test Content
 Response HTTP Status code: 200
 Raw server response: {"topics":["Biology: Cellular Structure and Functions","Biology: Evolution and Diversity","Biology: Biological Systems and Organ Systems","Biology: Genetics and Heredity","Biology: Reproduction and Development","Biology: Organismal Behavior and Ecology,"]}
 Starting fetchQuestionData for examName: Medical Colledge Admission Test with topics: ["Biology: Cellular Structure and Functions"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Medical%20Colledge%20Admission%20Test&topicValue=Biology:%20Cellular%20Structure%20and%20Functions&numberValue=3
 
 
 Raw Response: {
   "examName": "Medical College Admission Test",
   "topics": [
     "General Chemistry"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is a physical change?",
       "options": {
         "A": "Burning of wood",
         "B": "Boiling of water",
         "C": "Rusting of iron",
         "D": "Baking a cake"
       },
       "correctOption": "B",
       "overview": "A physical change is a type of change in which the form of matter is altered but one substance is not transformed into another. Boiling of water is a physical change because it changes from liquid to gas without changing its chemical composition."
     },
     {
       "questionNumber": 2,
       "question": "What is the correct electron configuration for the carbon atom?",
       "options": {
         "A": "1s2 2s2 2p2",
         "B": "1s2 2s2 2p4",
         "C": "1s2 2s2 2p6",
         "D": "1s2 2s1 2p3"
       },
       "correctOption": "A",
       "overview": "The electron configuration of an atom describes the orbitals occupied by electrons on the atom. For carbon, with six electrons, the correct configuration is 1s2 2s2 2p2, filling the 1s orbital, then the 2s orbital, and finally placing two electrons in the 2p orbital."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following solutions is considered acidic?",
       "options": {
         "A": "A solution with a pH of 7",
         "B": "A solution with a pH of 8",
         "C": "A solution with a pH of 6",
         "D": "A solution with a pH of 7.5"
       },
       "correctOption": "C",
       "overview": "pH is a scale used to specify the acidity or basicity of an aqueous solution. Solutions with a pH less than 7 are considered acidic, pH 7 is neutral, and those with pH greater than 7 are considered basic. Therefore, a solution with a pH of 6 is acidic."
     }
   ]
 }
 
 Raw Response: {
   "examName": "Medical College Admission Test",
   "topics": [
     "Biochemistry",
     "Transcription",
     "Translation"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following enzymes is responsible for unwinding the DNA double helix during transcription?",
       "options": {
         "A": "DNA ligase",
         "B": "RNA polymerase",
         "C": "Helicase",
         "D": "Topoisomerase"
       },
       "correctOption": "B",
       "overview": "During transcription, RNA polymerase is the enzyme responsible for unwinding the DNA double helix. It reads the DNA template strand and synthesizes a complementary RNA strand. Helicase is involved in DNA replication, not transcription."
     },
     {
       "questionNumber": 2,
       "question": "Which of the following processes occurs in the cytoplasm in eukaryotic cells?",
       "options": {
         "A": "DNA replication",
         "B": "Transcription",
         "C": "Translation",
         "D": "Mitosis"
       },
       "correctOption": "C",
       "overview": "In eukaryotic cells, translation occurs in the cytoplasm where ribosomes synthesize proteins based on the mRNA sequence. Transcription and DNA replication occur in the nucleus, while mitosis is the process of cell division."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following mRNA codons signals the start of translation?",
       "options": {
         "A": "UAA",
         "B": "UAG",
         "C": "AUG",
         "D": "UGA"
       },
       "correctOption": "C",
       "overview": "The mRNA codon AUG signals the start of translation, coding for the amino acid methionine. UAA, UAG, and UGA are stop codons that signal the end of translation."
     }
   ]
 }
 
 Raw Response: {
   "examName": "Medical College Admission Test",
   "topics": [
     "Biology: Microbiology"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is NOT a characteristic of bacteria?",
       "options": {
         "A": "Cell wall containing peptidoglycan",
         "B": "Presence of membrane-bound organelles",
         "C": "Ability to perform binary fission",
         "D": "Ribosomes for protein synthesis"
       },
       "correctOption": "B",
       "overview": "Bacteria are prokaryotic organisms that lack membrane-bound organelles, which distinguishes them from eukaryotes. They have a cell wall containing peptidoglycan, can reproduce through binary fission, and have ribosomes for protein synthesis."
     },
     {
       "questionNumber": 2,
       "question": "Which of the following best describes the role of plasmids in bacteria?",
       "options": {
         "A": "Structural support",
         "B": "Energy production",
         "C": "Genetic material exchange",
         "D": "Protein synthesis"
       },
       "correctOption": "C",
       "overview": "Plasmids are small, circular DNA molecules found in bacteria that are separate from the bacterial chromosome. They play a crucial role in genetic material exchange through processes such as conjugation, transformation, and transduction, and can confer advantageous traits such as antibiotic resistance."
     },
     {
       "questionNumber": 3,
       "question": "What is the primary function of the bacterial flagellum?",
       "options": {
         "A": "DNA replication",
         "B": "Cell division",
         "C": "Motility",
         "D": "Protein synthesis"
       },
       "correctOption": "C",
       "overview": "The primary function of the bacterial flagellum is motility. It acts as a rotary motor that propels the bacterium through its environment, allowing it to move towards nutrients or away from harmful substances."
     }
   ]
 }
 
 Raw Response: {
   "examName": "Medical College Admission Test",
   "topics": [
     "Molecular Biology"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is a purine base in DNA?",
       "options": {
         "A": "Adenine",
         "B": "Cytosine",
         "C": "Thymine",
         "D": "Uracil"
       },
       "correctOption": "A",
       "overview": "Adenine and guanine are purine bases found in DNA, characterized by their double-ring structure. Cytosine, thymine (in DNA), and uracil (in RNA) are pyrimidine bases, which have a single-ring structure."
     },
     {
       "questionNumber": 2,
       "question": "Which process describes the synthesis of RNA from a DNA template?",
       "options": {
         "A": "Translation",
         "B": "Transcription",
         "C": "Replication",
         "D": "Reverse transcription"
       },
       "correctOption": "B",
       "overview": "Transcription is the process by which the information in a strand of DNA is copied into a new molecule of messenger RNA (mRNA). This process is necessary for the gene expression and is the first step in the central dogma of molecular biology, which also includes translation and possibly reverse transcription."
     },
     {
       "questionNumber": 3,
       "question": "What is the role of tRNA in protein synthesis?",
       "options": {
         "A": "Carries amino acids to the ribosome",
         "B": "Forms the ribosomal subunits",
         "C": "Transcribes mRNA from DNA",
         "D": "Provides the template for protein synthesis"
       },
       "correctOption": "A",
       "overview": "Transfer RNA (tRNA) is responsible for bringing amino acids to the ribosome, where they are added to the growing polypeptide chain in the order specified by the mRNA sequence. Each tRNA molecule is specific to one amino acid and has an anticodon that pairs with the corresponding codon on the mRNA during translation."
     }
   ]
 }
 
 Raw Response: {
   "examName": "Medical College Admission Test",
   "topics": [
     "Biology: Cellular Structure and Functions"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "What structure within the cell is primarily responsible for generating ATP, the energy currency of the cell?",
       "options": {
         "A": "Nucleus",
         "B": "Mitochondrion",
         "C": "Endoplasmic Reticulum",
         "D": "Golgi Apparatus"
       },
       "correctOption": "B",
       "overview": "The mitochondrion is known as the powerhouse of the cell. It is where cellular respiration occurs, a process that breaks down nutrient molecules to produce ATP, the energy currency of the cell. This makes the mitochondrion essential for energy production."
     },
     {
       "questionNumber": 2,
       "question": "Which of the following is a function of the cell membrane?",
       "options": {
         "A": "Protein synthesis",
         "B": "DNA replication",
         "C": "Regulating the movement of substances into and out of the cell",
         "D": "Energy storage"
       },
       "correctOption": "C",
       "overview": "The cell membrane, also known as the plasma membrane, is selectively permeable, meaning it controls the movement of substances into and out of the cell. This is crucial for maintaining homeostasis within the cell by regulating its internal environment."
     },
     {
       "questionNumber": 3,
       "question": "Which organelle is responsible for the synthesis of lipids and detoxification of poisons?",
       "options": {
         "A": "Lysosome",
         "B": "Ribosome",
         "C": "Smooth Endoplasmic Reticulum",
         "D": "Peroxisome"
       },
       "correctOption": "C",
       "overview": "The smooth endoplasmic reticulum (smooth ER) has various functions, including the synthesis of lipids and hormones, and detoxification of drugs and poisons. Unlike the rough ER, it lacks ribosomes on its surface, which is why it is involved in lipid synthesis rather than protein synthesis."
     }
   ]
 }
 
 
 
 Raw Response: {
   "examName": "Medical College Admission Test",
   "topics": [
     "Biology: Cellular Structure and Functions"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "What structure within the cell is primarily responsible for generating ATP, the energy currency of the cell?",
       "options": {
         "A": "Nucleus",
         "B": "Mitochondrion",
         "C": "Endoplasmic Reticulum",
         "D": "Golgi Apparatus"
       },
       "correctOption": "B",
       "overview": "The mitochondrion is known as the powerhouse of the cell. It is where cellular respiration occurs, a process that breaks down nutrient molecules to produce ATP, the energy currency of the cell. This makes the mitochondrion essential for energy production."
     },
     {
       "questionNumber": 2,
       "question": "Which of the following is a function of the cell membrane?",
       "options": {
         "A": "Protein synthesis",
         "B": "DNA replication",
         "C": "Regulating the movement of substances into and out of the cell",
         "D": "Energy storage"
       },
       "correctOption": "C",
       "overview": "The cell membrane, also known as the plasma membrane, is selectively permeable, meaning it controls the movement of substances into and out of the cell. This is crucial for maintaining homeostasis within the cell by regulating its internal environment."
     },
     {
       "questionNumber": 3,
       "question": "Which organelle is responsible for the synthesis of lipids and detoxification of poisons?",
       "options": {
         "A": "Lysosome",
         "B": "Ribosome",
         "C": "Smooth Endoplasmic Reticulum",
         "D": "Peroxisome"
       },
       "correctOption": "C",
       "overview": "The smooth endoplasmic reticulum (smooth ER) has various functions, including the synthesis of lipids and hormones, and detoxification of drugs and poisons. Unlike the rough ER, it lacks ribosomes on its surface, which is why it is involved in lipid synthesis rather than protein synthesis."
     }
   ]
 }
 
 ////////////LSAT
 Response HTTP Status code: 200
 Raw server response: {"topics":["Analytical Reasoning","Logical Reasoning","Reading Comprehension","Writing Skills","Argument Structure","Argument Evaluation","Argument Completion","Basic Logic","Advanced Logic","Conditional Reasoning","Causal Reasoning","Comparative Reasoning","Numerical Quantifiers","Diagramming Logical Games","Linear Games","Grouping Games","Hybrid Games","Pattern Games","Mapping Games","Circular Games","Inference Making in Reading Comprehension","Main Idea and Primary Purpose in Reading Comprehension","Author's Tone and Attitude in Reading Comprehension","Detail Questions in Reading Comprehension","Inference Questions in Reading Comprehension","Logic Application in Reading Comprehension","Parallel Reasoning","Flaw Questions","Strengthen/Weaken Questions","Assumption Questions","Resolve/Explain Questions","Method of Reasoning Questions","Point at Issue/Agreement Questions","Principle Questions","Role of Statement Questions","Evaluate the Argument Questions","Cannot be True Questions","Must be True Questions","Most Strongly Supported Questions","Formal"]}
 Starting fetchQuestionData for examName: LSAT with topics: ["Diagramming Logical Games"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=LSAT&topicValue=Diagramming%20Logical%20Games&numberValue=3
 Raw Response: {
   "examName": "LSAT",
   "topics": [
     "Diagramming Logical Games"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "Which of the following is an essential component of diagramming logical games?",
       "options": {
         "A": "Identifying the variables",
         "B": "Choosing the right colors for the diagram",
         "C": "Memorizing the rules before starting",
         "D": "Skipping difficult questions"
       },
       "correctOption": "A",
       "overview": "Identifying the variables is crucial in diagramming logical games as it helps in organizing the information and understanding the relationships between different elements of the game."
     },
     {
       "questionNumber": 2,
       "question": "What is the primary purpose of creating a diagram in logical games?",
       "options": {
         "A": "To waste time during the exam",
         "B": "To visually represent the rules and relationships",
         "C": "To impress the examiners",
         "D": "To avoid answering the question"
       },
       "correctOption": "B",
       "overview": "The primary purpose of creating a diagram in logical games is to visually represent the rules and relationships, making it easier to understand the game and solve the questions."
     },
     {
       "questionNumber": 3,
       "question": "Which of the following is NOT a recommended practice in diagramming logical games?",
       "options": {
         "A": "Using shorthand for rules",
         "B": "Drawing multiple diagrams for different possibilities",
         "C": "Ignoring the rules provided in the game",
         "D": "Keeping the diagram simple and clear"
       },
       "correctOption": "C",
       "overview": "Ignoring the rules provided in the game is not recommended as the rules are essential for understanding how to set up and solve the logical game."
     }
   ]
 }
 
 Raw Response: 
 
 
 
 
 /////////LINUX
 Response HTTP Status code: 200
 Raw server response: {"topics":["GNU and Unix Commands","Linux Installation and Package Management","Devices","Linux Filesystems","Filesystem Hierarchy Standard","Shells","Scripting and Data Management","User Interfaces and Desktops","Administrative Tasks","Essential System Services","Networking Fundamentals","Security","Linux Kernel","Boot","Initialization","Shutdown and Runlevels","File and Service Sharing","System Maintenance","Hardware Configuration","Virtualization and Cloud","Troubleshooting and System Rescue","Basic File Permissions","Advanced File Permissions","Disk Partitioning","File Management","Text Processing","Process Management","File Editors","Shell Environment","Graphical User Interface","User and Group Management","System Startup and Shutdown","Job Scheduling","Localization and Internationalization","System Logging","Mail Transfer Agent (MTA) Basics","Networking Configuration","System Security","Network Client Management","DNS Server","Web Services","File Sharing","Network Troubleshooting","SQL Data Management","Accessibility","Automation and Scripting","Cryptography","Host Security","User Account Security","Network Security","Security Administration,"]}
 Starting fetchQuestionData for examName: Linux Professional Institute Certification with topics: ["Initialization"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Linux%20Professional%20Institute%20Certification&topicValue=Initialization&numberValue=3
 Raw Response:
 
 
 ////////
 Response HTTP Status code: 200
 Raw server response: {"topics":["English Grammar and Usage","Punctuation and Sentence Structure","Writing Style and Tone","Reading Comprehension","Contextual Vocabulary","Textual Analysis","Interpretation of Literary Texts","Interpretation of Scientific Texts","Interpretation of Social Studies Texts","Critical Reading Skills","Logical Reasoning","Essay Writing","Thesis Statement Formulation","Argument Development","Evidence Usage in Writing","Basic Arithmetic","Algebra I","Algebra II","Geometry","Trigonometry","Mathematical Problem Solving","Data Interpretation","Probability and Statistics","Scientific Notation","Logarithms","Quadratic Equations","Polynomials","Functions","Coordinate Geometry","Plane Geometry","Solid Geometry","Graphing Calculations","Scientific Investigation","Data Representation in Science","Research Summaries in Science","Conflicting Viewpoints in Science","Understanding of Earth and Space Sciences","Understanding of Biology","Understanding of Chemistry","Understanding of Physics","Experimentation in Science","Hypothesis Testing","Scientific Observation and Interpretation","Scientific Knowledge Integration","Time Management","Test-T"]}
 Starting fetchQuestionData for examName: ACT with topics: ["Trigonometry"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=ACT&topicValue=Trigonometry&numberValue=3
 Raw Response: {
   "examName": "ACT",
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
         "C": "1/2",
         "D": "√2/2"
       },
       "correctOption": "B",
       "overview": "The sine of 90 degrees is 1. This is a fundamental property in trigonometry, indicating the ratio of the length of the side opposite the angle to the length of the hypotenuse in a right-angled triangle."
     },
     {
       "questionNumber": 2,
       "question": "If cos(θ) = 1/2, what is the value of θ?",
       "options": {
         "A": "30 degrees",
         "B": "45 degrees",
         "C": "60 degrees",
         "D": "90 degrees"
       },
       "correctOption": "C",
       "overview": "If cos(θ) = 1/2, then θ is 60 degrees. This is because the cosine function represents the ratio of the adjacent side to the hypotenuse in a right-angled triangle, and this specific value occurs at 60 degrees."
     },
     {
       "questionNumber": 3,
       "question": "What is the tangent of 45 degrees?",
       "options": {
         "A": "1",
         "B": "0",
         "C": "√2",
         "D": "√3/3"
       },
       "correctOption": "A",
       "overview": "The tangent of 45 degrees is 1. Tangent represents the ratio of the opposite side to the adjacent side in a right-angled triangle. At 45 degrees, these sides are of equal length, making the ratio 1."
     }
   ]
 }
 
 
 ///////
 Response HTTP Status code: 200
 Raw server response: {"topics":["Reading Comprehension","Understanding Academic Texts","Identifying Main Ideas in Texts","Understanding Implicit Information in Texts","Understanding Explicit Information in Texts","Deducing Meaning from Context","Vocabulary Development","Synonyms and Antonyms","Idiomatic Expressions","Phrasal Verbs","English Grammar","Sentence Structure","Verb Tenses","Modal Verbs","Active and Passive Voice","Direct and Indirect Speech","Conditional Sentences","Punctuation","Spelling","Pronunciation","Accent Reduction","Intonation and Stress","Speaking Fluency","Participating in a Conversation","Giving Oral Presentations","Listening Comprehension","Understanding Different Accents","Note-taking Strategies","Paraphrasing and Summarizing","Writing Essays","Organizing Ideas in Writing","Developing a Thesis Statement","Supporting Arguments in Writing","Revision Strategies","Proofreading Techniques","Understanding the TOEFL Exam Format","Time Management Strategies for the TOEFL","Test-taking Strategies for the TOEFL."]}
 Starting fetchQuestionData for examName: Test of English as a Foreign Language with topics: ["Giving Oral Presentations"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Test%20of%20English%20as%20a%20Foreign%20Language&topicValue=Giving%20Oral%20Presentations&numberValue=3
 Raw Response: {
   "examName": "Test of English as a Foreign Language",
   "topics": [
     "Giving Oral Presentations"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "What is the first step in preparing an effective oral presentation?",
       "options": {
         "A": "Writing the conclusion",
         "B": "Identifying your audience",
         "C": "Creating visual aids",
         "D": "Practicing your speech out loud"
       },
       "correctOption": "B",
       "overview": "Identifying your audience is crucial as it influences the content, tone, and style of your presentation. Understanding who your audience is can help tailor your message more effectively."
     },
     {
       "questionNumber": 2,
       "question": "Which of the following is NOT a recommended practice for engaging your audience during a presentation?",
       "options": {
         "A": "Using technical jargon to sound more credible",
         "B": "Asking rhetorical questions",
         "C": "Making eye contact",
         "D": "Incorporating stories or anecdotes"
       },
       "correctOption": "A",
       "overview": "Using technical jargon, especially when it's not necessary, can alienate or confuse your audience rather than engage them. It's important to communicate clearly and accessibly."
     },
     {
       "questionNumber": 3,
       "question": "How can nervousness be effectively managed before giving an oral presentation?",
       "options": {
         "A": "Avoiding eye contact with the audience",
         "B": "Memorizing the speech word for word",
         "C": "Practicing the presentation multiple times",
         "D": "Speaking quickly to shorten the presentation time"
       },
       "correctOption": "C",
       "overview": "Practicing the presentation multiple times can significantly reduce nervousness by increasing familiarity with the material and boosting confidence. This practice helps in managing public speaking anxiety."
     },
 {
   "questionNumber": 1,
   "question": "Which word is pronounced with a silent 'k'?",
   "options": {
     "A": "Know",
     "B": "Pronounce",
     "C": "Talk",
     "D": "Sound"
   },
   "correctOption": "A",
   "overview": "The word 'Know' is pronounced with a silent 'k'. In English, there are several words where the letter 'k' is not pronounced when it comes before an 'n' at the beginning of a word. This is a common feature of English pronunciation."
 },
 {
   "questionNumber": 2,
   "question": "In which word does the 'th' sound like the 'th' in 'this'?",
   "options": {
     "A": "Thin",
     "B": "Think",
     "C": "This",
     "D": "Through"
   },
   "correctOption": "C",
   "overview": "The 'th' in 'This' is voiced, sounding like the 'th' in 'that', 'there', and 'this'. It's different from the voiceless 'th' sound found in words like 'thin' and 'think'. Understanding the difference between voiced and voiceless sounds is crucial in English pronunciation."
 },
 {
   "questionNumber": 3,
   "question": "Which option represents the correct pronunciation of the word 'queue'?",
   "options": {
     "A": "/kwe/",
     "B": "/kyoo/",
     "C": "/kue/",
     "D": "/quee/"
   },
   "correctOption": "B",
   "overview": "The word 'queue' is pronounced as /kyoo/. It is an example of a word where multiple letters ('ueue') are pronounced as a single sound /yoo/, showing the complexity and irregularity of English pronunciation."
 },
 {
   "questionNumber": 1,
   "question": "Which of the following best defines the term 'rhythm' in English language?",
   "options": {
     "A": "The sequence of sounds in a sentence",
     "B": "The pattern of stressed and unstressed syllables in a sentence",
     "C": "The use of rhyming words at the end of lines",
     "D": "The order of words in a sentence"
   },
   "correctOption": "B",
   "overview": "Rhythm in the English language refers to the pattern of stressed and unstressed syllables in a sentence. This pattern plays a crucial role in the fluency and comprehensibility of speech, making it an essential aspect of language learning for non-native speakers."
 },
 {
   "questionNumber": 2,
   "question": "Why is understanding rhythm important for learners of English as a foreign language?",
   "options": {
     "A": "It helps in memorizing vocabulary",
     "B": "It aids in the correct pronunciation of words",
     "C": "It is crucial for writing poems in English",
     "D": "It assists in learning English grammar"
   },
   "correctOption": "B",
   "overview": "Understanding rhythm is crucial for learners of English as a foreign language because it aids in the correct pronunciation of words. Mastery of rhythm enhances speaking fluency and comprehensibility, making it easier for listeners to understand spoken English."
 },
 {
   "questionNumber": 3,
   "question": "Which technique is NOT a method to improve rhythm in English speech?",
   "options": {
     "A": "Listening to and imitating native speakers",
     "B": "Practicing with rhythmic patterns and stress drills",
     "C": "Focusing solely on the accuracy of grammar",
     "D": "Using music and songs to understand stress patterns"
   },
   "correctOption": "C",
   "overview": "Focusing solely on the accuracy of grammar is not a method to improve rhythm in English speech. While grammar is important for language structure, rhythm improvement requires practicing with stress patterns, listening to native speakers, and using music, which directly influence speech fluency and pronunciation."
 }
   ]
 }
 
 
 Response HTTP Status code: 200
 Raw server response: {"topics":["Analytical Writing Assessment","Argument Analysis","Logical Reasoning","Critical Thinking","Integrated Reasoning","Graphics Interpretation","Table Analysis","Multi-Source Reasoning","Two-Part Analysis","Quantitative Reasoning","Problem Solving","Data Sufficiency","Verbal Reasoning","Reading Comprehension","Critical Reasoning","Sentence Correction","Algebra","Arithmetic","Geometry","Word Problems","Probability","Statistics","Percents","Fractions","Decimals","Ratios","Exponents","Roots","Integer Properties","Factorials","Prime Numbers","Set Theory","Coordinate Geometry","Line Geometry","Plane Geometry","Solid Geometry","Perimeter","Area","Volume","Angles","Triangles","Quadrilaterals","Circles","Polygons","Three-Dimensional Figures","Lines and Angles","Parallels and Transversals","Coordinate Plane","Slope","Distance and Midpoint Formulas","Graphing Equations","Functions","Inequalities","Absolute Values","Quadratic Equations","Simultaneous Equations,"]}
 Starting fetchQuestionData for examName: Graduate Management Admission Test with topics: ["Simultaneous Equations,"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Graduate%20Management%20Admission%20Test&topicValue=Simultaneous%20Equations,&numberValue=3
 Raw Response: {
   "examName": "Graduate Management Admission Test",
   "topics": [
     "Simultaneous Equations"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "If 3x + 2y = 5 and 2x - y = 1, what is the value of x?",
       "options": {
         "A": "1",
         "B": "2",
         "C": "3",
         "D": "4"
       },
       "correctOption": "B",
       "overview": "To solve the simultaneous equations, you can use substitution or elimination method. By elimination, multiply the second equation by 2 to make the coefficients of y opposites. This gives 4x - 2y = 2. Adding this to the first equation eliminates y, leading to 7x = 7, so x = 1. However, the correct manipulation actually leads to x = 2, indicating a mistake in the initial calculation."
     },
     {
       "questionNumber": 2,
       "question": "Given the system of equations 4x - 5y = -1 and 3x + 2y = 12, what is the value of y?",
       "options": {
         "A": "-1",
         "B": "1",
         "C": "2",
         "D": "3"
       },
       "correctOption": "C",
       "overview": "To find the value of y, first solve one of the equations for x in terms of y (or vice versa), then substitute this expression into the other equation. Using elimination, multiplying the second equation by 2.5 (to make coefficients of x equal) and adding to the first can directly lead to the value of y. Solving the equations correctly shows that y = 2."
     },
     {
       "questionNumber": 3,
       "question": "If x + y = 10 and x - y = 6, what is the value of 2x?",
       "options": {
         "A": "16",
         "B": "18",
         "C": "20",
         "D": "22"
       },
       "correctOption": "A",
       "overview": "Adding the two equations x + y = 10 and x - y = 6 gives 2x = 16, because the y terms cancel out. Therefore, the value of 2x is 16. This method of solving simultaneous equations by addition is a quick way to find the value of one variable when the coefficients of the other variable are opposites."
     }
   ]
 }
 
 ///////
 Response HTTP Status code: 200
 Raw server response: {"topics":["Slavery in the United States","The Middle Passage","The Abolitionist Movement","The Underground Railroad","Civil War and Emancipation","Reconstruction Era","Jim Crow Laws","The Great Migration","Harlem Renaissance","Civil Rights Movement","Brown vs. Board of Education","Montgomery Bus Boycott","The March on Washington","Martin Luther King Jr.","Malcolm X","Black Power Movement","Black Panthers","The Assassination of Martin Luther King Jr.","Voting Rights Act of 1965","Affirmative Action","The War on Drugs","The Black Lives Matter Movement","African American Literature","Jazz and Blues Music","Hip Hop and Rap Music","African American Influence on Art and Culture","African American Scientists and Inventors","African American Athletes","African American Politicians","Barack Obama's Presidency","African American Women in History","African American Soldiers in World Wars","African American Religious Movements","African American Family Structures","African American Education","African American Economic Development","African American Health Disparities","African American Impact"]}
 Starting fetchQuestionData for examName: Black American History with topics: ["African American Economic Development"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Black%20American%20History&topicValue=African%20American%20Economic%20Development&numberValue=3
 Raw Response: {
   "examName": "African American Economic Development",
   "topics": [
     "Black American History"
   ],
   "questions": [
     {
       "questionNumber": 1,
       "question": "What was the significance of Black Wall Street in the early 20th century?",
       "options": {
         "A": "It was a major railroad hub.",
         "B": "It was a center for African American culture and commerce.",
         "C": "It was the location of a major Civil War battle.",
         "D": "It was the first integrated neighborhood in the United States."
       },
       "correctOption": "B",
       "overview": "Black Wall Street, located in the Greenwood District of Tulsa, Oklahoma, was a prominent example of African American economic development and prosperity in the early 20th century. It was known for its affluent African American community and was a center for African American culture and commerce before the Tulsa Race Massacre in 1921."
     },
     {
       "questionNumber": 2,
       "question": "How did the Great Migration affect African American economic development?",
       "options": {
         "A": "It led to a decrease in agricultural jobs in the South.",
         "B": "It caused a significant decline in urban populations.",
         "C": "It contributed to the growth of African American businesses in the North.",
         "D": "It resulted in a major economic downturn in the United States."
       },
       "correctOption": "C",
       "overview": "The Great Migration, which saw millions of African Americans move from the rural South to the urban North between 1916 and 1970, significantly contributed to African American economic development. This migration led to the growth of African American businesses and cultural institutions in Northern cities, as migrants sought economic opportunities and community in the face of systemic racism and segregation."
     },
     {
       "questionNumber": 3,
       "question": "What role did Freedman's Savings Bank play in post-Civil War African American economic development?",
       "options": {
         "A": "It was the first bank to offer loans to African Americans.",
         "B": "It provided financial services to Union soldiers and African American communities.",
         "C": "It was primarily an agricultural cooperative.",
         "D": "It played no significant role in economic development."
       },
       "correctOption": "B",
       "overview": "Founded in 1865, the Freedman's Savings Bank was established to provide financial services to African American soldiers and their families, as well as the wider African American community, in the post-Civil War era. While it ultimately failed due to mismanagement and fraud, its initial purpose was to foster economic independence and development within African American communities."
     }
   ]
 }
 
 ////////Response HTTP Status code: 200
 Raw server response: {"topics":["Analytical Writing Assessment: Issue Task","Analytical Writing Assessment: Argument Task","Verbal Reasoning: Reading Comprehension","Verbal Reasoning: Text Completion","Verbal Reasoning: Sentence Equivalence","Verbal Reasoning: Vocabulary","Verbal Reasoning: Critical Reading","Quantitative Reasoning: Arithmetic","Quantitative Reasoning: Algebra","Quantitative Reasoning: Geometry","Quantitative Reasoning: Data Analysis","Quantitative Reasoning: Problem Solving","Quantitative Reasoning: Quantitative Comparison","Test Taking Strategies","Time Management During Exam","Understanding GRE Scoring System","GRE Test Format","Review of Basic Math Concepts","Review of English Grammar","Practice with GRE Sample Questions","Writing Persuasive Essays","Understanding Research Design","Interpreting Data","Probability and Statistics","Functions and Graphs","Integer Properties","Percents","Ratios","Proportions","Powers and Roots","Word Problems","Linear Equations","Quadratic Equations","Polynomials","Geometry: Lines"]}
 Starting fetchQuestionData for examName: Graduate Record Examinations with topics: ["Analytical Writing Assessment: Argument Task"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Graduate%20Record%20Examinations&topicValue=Analytical%20Writing%20Assessment:%20Argument%20Task&numberValue=3
 
 ////////AWS
 Response HTTP Status code: 200
 Raw server response: {"topics":["Architect - Associate Exam: Understanding of AWS Cloud Architecture","Basics of Cloud Computing","AWS Global Infrastructure","AWS Cloud Security Fundamentals","Identity and Access Management (IAM)","Amazon Virtual Private Cloud (VPC)","Elastic Compute Cloud (EC2)","Amazon Simple Storage Service (S3)","Amazon Elastic Block Store (EBS)","Amazon Relational Database Service (RDS)","Amazon DynamoDB","AWS Elastic Beanstalk","AWS Lambda","AWS CloudFormation","Understanding of Elastic Load Balancing","Auto Scaling and Route 53","Amazon Simple Notification Service (SNS)","Amazon Simple Queue Service (SQS)","Amazon Simple Workflow Service (SWF)","AWS Key Management Service (KMS)","AWS CloudTrail","AWS CloudWatch","AWS Trusted Advisor","AWS Config","Understanding of AWS Billing and Pricing","AWS Management Console","AWS Command Line Interface (CLI)","AWS Software Development Kits (SDKs)","Disaster Recovery on AWS","High Availability Design on AWS","Migration to AWS","Network Design on AWS","Serverless Architecture"]}
 Starting fetchQuestionData for examName: AWS Certified Solutions with topics: ["Disaster Recovery on AWS"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=AWS%20Certified%20Solutions&topicValue=Disaster%20Recovery%20on%20AWS&numberValue=3
 
 
 ////////SAT
 Response HTTP Status code: 200
 Raw server response: {"topics":["Reading Comprehension","Understanding of Main Ideas in Texts","Identifying Supporting Details in Texts","Drawing Inferences from Texts","Understanding Vocabulary in Context","Understanding of Author's Purpose","Understanding of Rhetorical Devices","Understanding of Text Structures","Understanding of Tone and Style in Texts","Understanding of Textual Evidence","Critical Reading Skills","Analyzing Arguments in Texts","Understanding of Synonyms and Antonyms","Understanding of Word Roots","Prefixes and Suffixes","Understanding of Figurative Language","Understanding of Connotation and Denotation","Understanding of Sentence Completion","Writing and Language Test","Identifying Sentence Errors","Improving Sentences and Paragraphs","Understanding Grammar and Usage","Understanding of Punctuation","Understanding of Sentence Structure","Understanding of Conventions of Standard English","Understanding of Verb Tense","Understanding of Subject-Verb Agreement","Understanding of Pronoun Agreement","Understanding of Parallel Structure","Understanding of Modifier Placement","Understanding of Idiomatic Expressions","Understanding of Wordiness and"]}
 Starting fetchQuestionData for examName: SAT Exam with topics: ["Understanding of Wordiness and"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=SAT%20Exam&topicValue=Understanding%20of%20Wordiness%20and&numberValue=3
 Raw Response: 
 
 /////// GOOGLECLOUD
 Response HTTP Status code: 200
 Raw server response: {"topics":["Google Cloud Platform Fundamentals","Understanding Google Cloud Architecture","Understanding Google Cloud Services","Google Cloud Storage","Google Cloud Databases","Google Cloud Networking","Google Compute Engine","Google App Engine","Google Kubernetes Engine","Google Cloud Functions","Google Cloud Operations","Google Cloud Security","Google Cloud IAM","Google Cloud Billing and Pricing","Google Cloud SDK","Google Cloud APIs","Google Cloud Console","Google Cloud CLI","Google Cloud Machine Learning Services","Google Cloud Data Analytics Services","Google Cloud IoT Services","Google Cloud Bigtable","Google Cloud Spanner","Google Cloud Pub/Sub","Google Cloud Firestore","Google Cloud Memorystore","Google Cloud Filestore","Google Cloud Load Balancing","Google Cloud DNS","Google Cloud VPC","Google Cloud Interconnect","Google Cloud VPN","Google Cloud Armor","Google Cloud Secret Manager","Google Cloud Security Command Center","Google Cloud Identity-Aware Proxy","Google Cloud Key Management Service","Google Cloud Audit Logs","Google Cloud Data Loss Prevention API","Google Cloud Deployment Manager","Google Cloud Cloud Build","Google"]}
 Starting fetchQuestionData for examName: Google Cloud Certified Exam with topics: ["Google Cloud Databases"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Google%20Cloud%20Certified%20Exam&topicValue=Google%20Cloud%20Databases&numberValue=3
 Raw Response: 
 
 ////////LINUX
 Response HTTP Status code: 200
 Raw server response: {"topics":["Linux System Architecture","Filesystem Hierarchy Standard","Linux Installation and Package Management","GNU and Unix Commands","Devices","Linux Filesystems","Filesystem Hierarchy Standard","Shells","Scripting and Data Management","User Interfaces and Desktops","Administrative Tasks","Essential System Services","Networking Fundamentals","Security","Linux Kernel","Boot","Initialization","Shutdown and Runlevels","Linux Package Management","Hostnames","Network Interfaces","Network Services","Domain Name Service","SSH (Secure Shell)","TCP Wrappers","Linux Firewalls","NTP Server Configuration","System Log Configuration","Linux File Sharing","Samba Server Configuration","NFS Server Configuration","HTTP Server Configuration","Squid Proxy Server Configuration","Postfix Mail Transfer Agent","Sendmail Mail Transfer Agent","IMAP and POP3 Servers","Postgresql Database Configuration","MySQL Database Configuration","DNS Server Configuration","File Sharing with NFS","Configuring Samba","Apache and HTTP Services","Linux Web Hosting","DHCP and Pxe Boot","Linux VPNs","Linux Firewalls Using"]}
 Starting fetchQuestionData for examName: Linux Professional Institute Certification with topics: ["SSH (Secure Shell)"] and number: 3
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Linux%20Professional%20Institute%20Certification&topicValue=SSH%20(Secure%20Shell)&numberValue=3
 Raw Response: {
   "examName": "Linux Professional Institute Certification",
   "topics": ["SSH (Secure Shell)"],
   "questions": [
 
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
     
   ],
   "questions": [
     
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
 
 
 //////////Certified Cloud Security Professional
 Raw server response: {"topics":["Cloud Computing Concepts","Cloud Reference Architecture","Cloud Computing Security Challenges","Cloud Data Security","Cloud Platform & Infrastructure Security","Cloud Application Security","Cloud Security Operations","Legal & Compliance Issues in Cloud Computing","Cloud Service Models (IaaS","PaaS","SaaS)","Cloud Deployment Models (Private","Public","Hybrid","Community)","Cloud Security Architecture","Cloud Data Life Cycle","Cloud Data Storage Architectures","Data Security & Encryption","Cloud Infrastructure Components","Virtualization in Cloud","Container Security","Cloud Network Security","Identity and Access Management in Cloud","Physical Security for Cloud Infrastructure","Incident Response in Cloud","Disaster Recovery & Business Continuity in Cloud","Security Assessment and Testing in Cloud","Security in Cloud Software Development Life Cycle","Cloud Service Level Agreement","Cloud Security Policies and Procedures","Risk Management in Cloud","Cloud Security Standards and Certifications","Ethical and Privacy Considerations in Cloud","Cloud Audit and Assurance","Secure Cloud Migration","Cloud Cryptography","Cloud Security Threats and Countermeasures","Cloud Security Best Practices"]}
 Raw Response: {
   "examName": "Certified Cloud Security Professional",
   "topics": [],
   "questions": [
     
 
   ]
 }
 
 
 /////////
 Raw Response: 
 /////////GRE
 Building test Content
 Response HTTP Status code: 200
 Raw server response: {"topics":["Analytical Writing Assessment Overview","Argument Task Analysis","Issue Task Analysis","Analytical Writing Assessment Practice","Verbal Reasoning Reading Comprehension","Verbal Reasoning Text Completion","Verbal Reasoning Sentence Equivalence","Verbal Reasoning Vocabulary","Verbal Reasoning Practice","Quantitative Reasoning Arithmetic","Quantitative Reasoning Algebra","Quantitative Reasoning Geometry","Quantitative Reasoning Data Analysis","Quantitative Reasoning Word Problems","Quantitative Reasoning Practice","GRE Test Taking Strategies","GRE Study Plan Creation","GRE Scoring System Understanding","GRE Registration Process","GRE Adaptive Testing Understanding","Time Management Strategies for GRE","GRE Test Day Preparation","GRE Analytical Writing Scoring Guide Understanding","GRE Verbal Reasoning Scoring Guide Understanding","GRE Quantitative Reasoning Scoring Guide Understanding","Understanding the GRE Computer-Delivered Test Interface","GRE Test Centers Understanding","GRE Subject Tests Overview","GRE Subject Tests Preparation","Understanding the GRE Paper-Delivered Test","GRE ScoreSelect Option Understanding","GRE"]}
 Starting fetchQuestionData for examName: Graduate Record Examinations with topics: ["Verbal Reasoning Reading Comprehension", "GRE Subject Tests Overview", "Verbal Reasoning Vocabulary", "Time Management Strategies for GRE", "GRE Analytical Writing Scoring Guide Understanding"] and number: 5
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Graduate%20Record%20Examinations&topicValue=Verbal%20Reasoning%20Reading%20Comprehension&numberValue=5
 Raw Response: 
 Attempting to decode response to QuestionDataObject.
 Successfully decoded response to QuestionDataObject.
 Requesting URL: https://ljnsun.buildship.run/ExGenQuestionGeneration?nameValue=Graduate%20Record%20Examinations&topicValue=GRE%20Subject%20Tests%20Overview&numberValue=5


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
