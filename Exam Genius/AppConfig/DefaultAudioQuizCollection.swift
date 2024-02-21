//
//  DefaultAudioQuizCollection.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 2/9/24.
//

import Foundation

enum DefaultAudioQuizCollection: String, CaseIterable {
    case californiaBar = "California Bar"
    case mcat = "MCAT"
    case usmleStep1 = "USMLE Step 1"
    case cpaExam = "CPA Exam"
    case nclexRN = "NCLEX-RN"
    case pmpExam = "PMP Exam"
    case lsat = "LSAT"
    case comptiaAPlus = "CompTIA A+"
    case peExam = "PE Exam"
    case cfpExam = "CFP Exam"
    case baristaCertification = "Barista Certification"
    case realEstateLicensingExam = "Real Estate Licensing Exam"
    case architectRegistrationExam = "Architect Registration Exam"
    case series7Exam = "Series 7 Exam"
    case gre = "GRE (Graduate Record Examination)"
    case toefl = "TOEFL (Test of English as a Foreign Language)"
    case gmat = "GMAT (Graduate Management Admission Test)"
    case cfa = "CFA (Chartered Financial Analyst) Exam"
    case ccna = "CCNA (Cisco Certified Network Associate)Exam"
    case bptc = "Bar Professional Training Course (BPTC)"
    case mccqe = "Medical Council of Canada Qualifying Exam (MCCQE)"
    case cehExam = "Certified Ethical Hacker (CEH) Exam"
    case cisspExam = "Certified Information Systems Security Professional (CISSP)Exam"
    case csmExam = "Certified ScrumMaster (CSM) Exam"
    case cssgbExam = "Certified Six Sigma Green Belt (CSSGB) Exam"
    case cisaExam = "Certified Information Systems Auditor (CISA) Exam"
    case nce = "National Counselor Examination for Licensure and Certification (NCE)"
    case ncmhce = "National Clinical Mental Health Counseling Examination (NCMHCE)"
    case swiftProgrammingLanguage = "Swift Programming Language"
    case actExam = "ACT Exam"
    case satExam = "SAT Exam"
    case apExams = "Advanced Placement (AP) Exams"
    case datExam = "Dental Admission Test (DAT)"
    case oatExam = "Optometry Admission Test (OAT)"
    case pcateExam = "Pharmacy College Admission Test (PCAT)"
    case vetTec = "Veterinary Technician National Exam (VTNE)"
    case praxisExam = "Praxis Exam (for teachers)"
    case feExam = "Fundamentals of Engineering (FE) Exam"
    case seExam = "Structural Engineering (SE) Exam"
    case itilCertification = "ITIL Certification Exam"
    case prince2Certification = "PRINCE2 Certification Exam"
    case sapCertification = "SAP Certification Exam"
    case awsCertifiedSolutionsArchitect = "AWS Certified Solutions Architect Exam"
    case googleCloudCertified = "Google Cloud Certified Exam"
    case azureFundamentals = "Microsoft Azure Fundamentals Exam"
    case cybersecurityAnalystCySA = "Cybersecurity Analyst (CySA+)"
    case networkPlus = "CompTIA Network+"
    case securityPlus = "CompTIA Security+"
    case linuxProfessionalInstituteCertification = "Linux Professional Institute Certification (LPIC)"
    case certifiedCloudSecurityProfessional = "Certified Cloud Security Professional (CCSP)"
    case projectManagementProfessional = "Project Management Professional (PMP)"
    case certifiedSupplyChainProfessional = "Certified Supply Chain Professional (CSCP)"
    case certifiedProductionAndInventoryManagement = "Certified in Production and Inventory Management (CPIM)"
    case certifiedHealthcareFinancialProfessional = "Certified Healthcare Financial Professional (CHFP)"
    case certifiedManagementAccountant = "Certified Management Accountant (CMA)"
    case certifiedPublicAccountant = "Certified Public Accountant (CPA)"
    case certifiedInternalAuditor = "Certified Internal Auditor (CIA)"
    case certifiedFraudExaminer = "Certified Fraud Examiner (CFE)"
    case informationTechnologyInfrastructureLibrary = "Information Technology Infrastructure Library (ITIL)"
    case sixSigmaCertification = "Six Sigma Certification"
    case tableauDesktopSpecialist = "Tableau Desktop Specialist"
    case privacyEngineering = "Privacy Engineering"
    case cloudComputing = "Cloud Computing"
    case usCitizenship = "US Citizenship"
    case uiUxDesign = "UI and UX Design"
    case driversLicense = "Drivers License Test"
    case kotlin = "Kotlin"
    
    var image: String {
        switch self {
        case .californiaBar:
            "BarExam-Exam"
        case .mcat:
            "MCAT-Exam"
        case .usmleStep1:
            "USMLESTEP1-Exam"
        case .cpaExam:
            "CPA-Exam"
        case .nclexRN:
            "NCLEX-RN-Exam"
        case .pmpExam:
            "PMP-Exam"
        case .lsat:
            ""
        case .comptiaAPlus:
            "COMPTIA-APlus-Exam"
        case .peExam:
            "PE-Exam"
        case .cfpExam:
            "CFP-Exam"
        case .baristaCertification:
            "BARISTERCert-Exam"
        case .realEstateLicensingExam:
            "RealEstate-Exam"
        case .architectRegistrationExam:
            "ArchitectRegistration-Exam"
        case .series7Exam:
            "Series7-Exam"
        case .gre:
            "GRE-Exam"
        case .toefl:
            "TOFEL-Exam"
        case .gmat:
            "GMAT-Exam"
        case .cfa:
            "CFA-Exam"
        case .ccna:
            "CCNA-Exam"
        case .bptc:
            "BPTC-Exam"
        case .mccqe:
            "MCCQE-Exam"
        case .cehExam:
            "CertifiedEthicalHacker-Exam"
        case .cisspExam:
            ""
        case .csmExam:
            "CISA-Exam"
        case .cssgbExam:
            ""
        case .cisaExam:
            "CISA-Exam"
        case .nce:
            "NCE-Exam"
        case .ncmhce:
            "NCMHCE-Exam"
        case .swiftProgrammingLanguage:
            "SwiftProgramming"
        case .kotlin:
            "Kotlin"
        case .privacyEngineering:
            "PrivacyEngineering"
        case .cloudComputing:
            "CloudComputing"
        case .usCitizenship:
            "USCitizenship"
        case .uiUxDesign:
            "UIandUXDesign"
        case .actExam:
            ""
        case .satExam:
            ""
        case .apExams:
            ""
        case .datExam:
            ""
        case .oatExam:
            ""
        case .pcateExam:
            ""
        case .vetTec:
            ""
        case .praxisExam:
            ""
        case .feExam:
            ""
        case .seExam:
            ""
        case .itilCertification:
            ""
        case .prince2Certification:
            ""
        case .sapCertification:
            ""
        case .awsCertifiedSolutionsArchitect:
            ""
        case .googleCloudCertified:
            ""
        case .azureFundamentals:
            ""
        case .cybersecurityAnalystCySA:
            ""
        case .networkPlus:
            ""
        case .securityPlus:
            ""
        case .linuxProfessionalInstituteCertification:
            ""
        case .certifiedCloudSecurityProfessional:
            ""
        case .projectManagementProfessional:
            ""
        case .certifiedSupplyChainProfessional:
            ""
        case .certifiedProductionAndInventoryManagement:
            ""
        case .certifiedHealthcareFinancialProfessional:
            ""
        case .certifiedManagementAccountant:
            ""
        case .certifiedPublicAccountant:
            ""
        case .certifiedInternalAuditor:
            ""
        case .certifiedFraudExaminer:
            ""
        case .informationTechnologyInfrastructureLibrary:
            ""
        case .sixSigmaCertification:
            ""
        case .tableauDesktopSpecialist:
            ""
        case .driversLicense:
            "featuredDriversLicenseExam"
        }
    }
    
    var category: String {
        switch self {
        case .californiaBar, .lsat, .bptc:
            return "Legal"
        case .mcat, .usmleStep1, .nclexRN, .mccqe:
            return "Healthcare"
        case .cpaExam, .cfa, .cfpExam, .certifiedManagementAccountant, .certifiedPublicAccountant, .certifiedInternalAuditor, .certifiedFraudExaminer:
            return "Business & Finance"
        case .pmpExam, .csmExam, .prince2Certification, .projectManagementProfessional:
            return "Project Management"
        case .comptiaAPlus, .ccna, .cehExam, .cisspExam, .cybersecurityAnalystCySA, .networkPlus, .securityPlus, .linuxProfessionalInstituteCertification, .certifiedCloudSecurityProfessional, .awsCertifiedSolutionsArchitect, .googleCloudCertified, .azureFundamentals:
            return "Technology & Cybersecurity"
        case .peExam, .feExam, .seExam:
            return "Engineering"
        case .gre, .toefl, .gmat, .satExam, .actExam:
            return "General Education & College Admission"
        case .apExams, .datExam, .oatExam, .pcateExam, .vetTec, .praxisExam:
            return "Specialized Professional & Education"
        case .realEstateLicensingExam, .architectRegistrationExam, .series7Exam, .itilCertification, .sapCertification, .certifiedSupplyChainProfessional, .certifiedProductionAndInventoryManagement, .certifiedHealthcareFinancialProfessional, .informationTechnologyInfrastructureLibrary, .sixSigmaCertification, .tableauDesktopSpecialist:
            return "Miscellaneous Professional"
        case .baristaCertification:
            return "Vocational & Training"
        case .swiftProgrammingLanguage:
            return "Programming & Development"
        default:
            return "Other"
        }
    }
}

extension DefaultAudioQuizCollection {
    static var allCases: [DefaultAudioQuizCollection] {
        return [.californiaBar, .mcat, .usmleStep1, .cpaExam, .nclexRN, .pmpExam, .lsat, .comptiaAPlus, .peExam, .cfpExam, .baristaCertification, .realEstateLicensingExam, .architectRegistrationExam, .series7Exam, .gre, .toefl, .gmat, .cfa, .ccna, .bptc, .mccqe, .cehExam, .cisspExam, .csmExam, .cssgbExam, .cisaExam, .nce, .ncmhce, .swiftProgrammingLanguage]
    }
    
    static var freeCollection: [DefaultAudioQuizCollection] {
        return [.usCitizenship,.apExams, .datExam, .oatExam, .pcateExam, .vetTec, .praxisExam, .baristaCertification]
    }
    
    static var topPicks: [DefaultAudioQuizCollection] {
        return [.mcat, .usmleStep1, .nclexRN, .cybersecurityAnalystCySA, .linuxProfessionalInstituteCertification, .californiaBar, .comptiaAPlus]
    }
    
    static var generalEducation: [DefaultAudioQuizCollection] {
        return [.apExams, .datExam, .oatExam, .pcateExam, .vetTec, .praxisExam]
    }
    
    static var uniqueCategories: [String] {
        let allCategories = DefaultAudioQuizCollection.allCases.map { $0.category }
        return Array(Set(allCategories)).sorted()
    }
}





