//
//  DefaultDatabase.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/22/24.
//

import Foundation

struct DefaultDatabase {
    
    func getAllExamDetails() -> [ExamDetails] {
        [
            ExamDetails(name: "California Bar Exam", acronym: "CBX", category: [.legal], about: "A licensure exam for practicing law in California.", image: "BarExam-Exam"),
            
            ExamDetails(name: "Certified Public Accountant Exam", acronym: "CPA", category: [.business, .finance, .professional, .topCollection, .topProfessionalCertification], about: "Exam for accounting professionals to become certified public accountants in the USA.", image: "CPA-Exam"),
            
            ExamDetails(name: "National Council Licensure Examination for Registered Nurses", acronym: "NCLEX-RN", category: [.healthcare], about: "A national exam for the licensing of nurses in the USA.", image: "NCLEX-RN-Exam"),
            
            ExamDetails(name: "Project Management Professional Exam", acronym: "PMP", category: [.business], about: "Certification exam for project managers.", image: "PMP-Exam"),
            
            ExamDetails(name: "Law School Admission Test", acronym: "LSAT", category: [.legal, .topColledgePicks], about: "A standardized test for admissions to law schools in the USA.", image: "LSAT-Exam-Basic"),
            
            ExamDetails(name: "CompTIA A+", acronym: "A+", category: [.technology], about: "Certification for entry-level computer technicians.", image: "COMPTIA-APlus-Exam"),
            
            ExamDetails(name: "Professional Engineer Exam", acronym: "PE", category: [.engineering], about: "Licensure exam for engineers to become professionally certified.", image: "PE-Exam"),
            
            ExamDetails(name: "Certified Financial Planner Exam", acronym: "CFP", category: [.finance], about: "Certification exam for financial planners.", image: "CFP-Exam"),
            
            ExamDetails(name: "Real Estate Licensing Exam", acronym: "RELE", category: [.business], about: "Licensing exam for real estate agents.", image: "RealEstate-Exam"),
            
            ExamDetails(name: "Architect Registration Exam", acronym: "ARE", category: [.engineering], about: "Licensing exam for architects.", image: "ArchitectRegistration-Exam"),
            
            ExamDetails(name: "Series 7 Exam", acronym: "Series 7", category: [.finance], about: "Qualification exam for stockbrokers in the USA.", image: "Series7-Exam"),
            
            ExamDetails(name: "Graduate Record Examinations", acronym: "GRE", category: [.education, .topColledgePicks], about: "A standardized test for admissions to graduate schools.", image: "GRE-Exam"),
            
            ExamDetails(name: "Test of English as a Foreign Language", acronym: "TOEFL", category: [.language, .topColledgePicks, .education], about: "A standardized test to measure the English language ability of non-native speakers.", image: "TOFEL-Exam"),
            
            ExamDetails(name: "Graduate Management Admission Test", acronym: "GMAT", category: [.topColledgePicks, .education], about: "A test for admissions to business schools.", image: "GMAT-Exam"),
            
            ExamDetails(name: "Chartered Financial Analyst Exam", acronym: "CFA", category: [.finance], about: "A professional credential offered internationally by the American-based CFA Institute to investment and financial professionals.", image: "CFA-Exam"),
            
            ExamDetails(name: "Cisco Certified Network Associate Exam", acronym: "CCNA", category: [.technology], about: "A certification for network administrators, supporting and configuring IP networks.", image: "CCNA-Exam"),
            
            ExamDetails(name: "Bar Professional Training Course", acronym: "BPTC", category: [.legal, .professional], about: "Training course in England and Wales that bridges the gap between academic legal study and being a practicing barrister.", image: "BPTC-Exam"),
            
            ExamDetails(name: "Medical Council of Canada Qualifying Exam", acronym: "MCCQE", category: [.healthcare], about: "A two-part examination that assesses the competency of medical graduates, allowing them to practice medicine in Canada.", image: "MCCQE-Exam"),
            
            ExamDetails(name: "Certified Ethical Hacker Exam", acronym: "CEH", category: [.technology], about: "Certification for IT professionals seeking to prove their skills in ethical hacking and penetration testing.", image: "CertifiedEthicalHacker-Exam"),
            
            ExamDetails(name: "Certified Information Systems Security Professional Exam", acronym: "CISSP", category: [.technology], about: "An advanced-level certification for IT pros serious about careers in information security.", image: "CISSP-Exam"),
            
            ExamDetails(name: "Certified ScrumMaster Exam", acronym: "CSM", category: [.business, .professional, .topProfessionalCertification], about: "Certification for project managers in agile development methodology to lead Scrum teams.", image: "CSM-Exam"),
            
            ExamDetails(name: "Certified Six Sigma Green Belt Exam", acronym: "CSSGB", category: [.business], about: "Certification that recognizes professionals who are skilled in facilitating team activities within Six Sigma.", image: "CSSGB-Exam-Basic"),
            
            ExamDetails(name: "Certified Information Systems Auditor Exam", acronym: "CISA", category: [.technology], about: "Certification for information technology audit professionals.", image: "CISA-Exam"),
            
            ExamDetails(name: "National Counselor Examination for Licensure and Certification", acronym: "NCE", category: [.healthcare], about: "A certification for counselors in the U.S. that assesses knowledge and skills to practice safely and effectively.", image: "NCE-Exam"),
            
            ExamDetails(name: "National Clinical Mental Health Counseling Examination", acronym: "NCMHCE", category: [.healthcare], about: "An examination that tests for knowledge in the field of mental health counseling.", image: "NCMHCE-Exam"),
            
            ExamDetails(name: "Swift Programming Language", acronym: "Swift", category: [.technology], about: "Certification for developers in the Swift programming language, used for iOS and macOS applications.", image: "SwiftProgramming"),
            
            ExamDetails(name: "ACT Exam", acronym: "ACT", category: [.education, .topColledgePicks], about: "A standardized test for high school achievement and college admissions in the United States.", image: "ACT-Exam-Basic"),
            
            ExamDetails(name: "Advanced Placement Exams", acronym: "AP", category: [.education, .topColledgePicks], about: "Exams that offer high school students the opportunity to earn college credit, advanced placement, or both, in various subject areas.", image: "AFP-Exam-Basic"),
            
            ExamDetails(name: "Dental Admission Test", acronym: "DAT", category: [.healthcare], about: "A standardized test to assess the qualification of dental school applicants in the United States and Canada.", image: "DAT-Exam-Basic"),
            
            ExamDetails(name: "US Citizenship Test", acronym: "USC", category: [.legal, .history], about: "", image: "USCitizenship"),
            
            ExamDetails(name: "UI and UX Design", acronym: "Ui/Ux", category: [.technology], about: "", image: "UIandUXDesign"),
            
            ExamDetails(name: "Kotlin Programming Language", acronym: "Kotlin", category: [.technology], about: "", image: "Kotlin"),
            
            ExamDetails(name: "AWS Certified Solutions Architect Exam", acronym: "AWS CSA", category: [.technology, .topCollection], about: "Certification for individuals designing distributed systems on AWS.", image: "AWS-Exam-Basic"),
            
            ExamDetails(name: "Microsoft Azure Fundamentals Exam", acronym: "Azure Fundamentals", category: [.technology, .topProfessionalCertification], about: "Certification covering basic Azure concepts and services", image: "Azure-Exam-Basic"),
            
            ExamDetails(name: "Cybersecurity Analyst Exam", acronym: "CySA+", category: [.technology, .topProfessionalCertification], about: "Certification for IT cybersecurity analysts focusing on threat detection and response.", image: "CYSA-Exam-Basic"),
            
            ExamDetails(name: "CompTIA Network+", acronym: "Network+", category: [.technology, .topProfessionalCertification], about: "Certification for networking professionals.", image: "COMPTIA-Exam-Basic"),
            
            ExamDetails(name: "CompTIA Security+", acronym: "Security+", category: [.technology, .topProfessionalCertification], about: "Certification dealing with core cybersecurity skills.", image: "COMPTIA-Security-Exam-Basic"),
            
            ExamDetails(name: "Certified Supply Chain Professional", acronym: "CSCP", category: [.business], about: "Certification for supply chain management professionals.", image: "CSCP-Exam-Basic"),
            
            ExamDetails(name: "Production and Inventory Management Certification Exam", acronym: "CPIM", category: [.business], about: "Certification for professionals in production and inventory management.", image: "CPIM-Exam-Basic"),
            
            ExamDetails(name: "Certified Healthcare Financial Professional", acronym: "CHFP", category: [.finance], about: "Certification focusing on financial strategies in healthcare.", image: "CHFP-Exam-Basic"),
            
            ExamDetails(name: "Certified Management Accountant", acronym: "CMA", category: [.finance], about: "Certification for accountants and financial professionals in business.", image: "CMA-Exam-Basic"),
            
            ExamDetails(name: "Certified Internal Auditor", acronym: "CIA", category: [.finance, .professional, .topProfessionalCertification], about: "Certification for professionals who conduct internal audits.", image: "CIA-Exam-Basic"),
            
            ExamDetails(name: "Certified Fraud Examiner", acronym: "CFE", category: [.finance], about: "The CFE Exam tests knowledge in financial fraud, law, investigations, and fraud prevention and deterrence, administered by ACFE.", image: "CFE-Exam-Basic"),
            
            ExamDetails(name: "United States Medical Licensing Examination Step 1", acronym: "USMLE Step 1", category: [.healthcare, .topProfessionalCertification, .topColledgePicks], about: "Assesses whether medical students or graduates understand and can apply important concepts of the basic sciences to the practice of medicine. Focuses on principles and mechanisms underlying health, disease, and modes of therapy.", image: "USMLESTEP1-Exam"),
            
            ExamDetails(name: "Medical Colledge Admission Test", acronym: "MCAT", category: [.healthcare, .topCollection, .topColledgePicks], about: "A computer-based standardized examination for prospective medical students, including both Allopathic M.D. and Osteopathic D.O., in the United States, Australia, Canada, and the Caribbean Island", image: "MCAT-Exam-Pro"),
            
            ExamDetails(name: "Barista Certification", acronym: "", category: [.professional], about: "", image: "BARISTERCert-Exam"),
            
            ExamDetails(name: "Law School Admission Test", acronym: "LSAT", category: [.legal, .education, .topColledgePicks], about: "A standardized test administered by the Law School Admission Council (LSAC) for prospective law school candidates", image: "LSAT-Exam-Basic"),
            
            ExamDetails(name: "Certified Cloud Security Professional", acronym: "CCSP", category: [.technology, .topProfessionalCertification], about: "Certification for IT and information security leaders in cloud security.", image: "CloudComputing"),
            

            ExamDetails(name: "Privacy Engineering", acronym: "Privacy", category: [.technology, .business], about: " This series test knowledge of guidelines for privacy engineering, including the management of privacy risks in the design and development of systems", image: "PrivacyEngineering"),

            
            ExamDetails(name: "United States Medical Licensing Examination Step 2 Clinical Knowledge", acronym: "USMLE Step 2 CK", category: [.healthcare, .topColledgePicks, .topProfessionalCertification], about: "Tests medical knowledge and understanding of clinical science necessary for the provision of patient care under supervision, with an emphasis on health promotion and disease prevention.", image: "USMLE-Step-2-CK-Basic"),
            
            ExamDetails(name: "United States Medical Licensing Examination Step 3", acronym: "USMLE Step 3", category: [.healthcare, .topProfessionalCertification, .topColledgePicks], about: "Assesses whether participants can apply medical knowledge and understanding of biomedical and clinical science essential for the unsupervised practice of medicine, with an emphasis on patient management in ambulatory settings.", image: "USMLE-Step-3-Basic"),
            
            ExamDetails(name: "SAT Exam", acronym: "SAT", category: [.topCollection, .education, .topColledgePicks], about: "A standardized test widely used for college admissions in the United States.", image: "SAT-Exam"),
            
            ExamDetails(name: "Pharmacy College Admission Test", acronym: "PCAT", category: [.healthcare], about: "A computer-based standardized test that helps to identify qualified applicants to pharmacy colleges.", image: "PCAT-Exam"),
            
            ExamDetails(name: "Veterinary Technician National Exam", acronym: "VTNE", category: [.healthcare], about: "A credentialing examination for veterinary technicians.", image: "VTNE-Exam"),
            
            ExamDetails(name: "Optometry Admission Test", acronym: "OAT", category: [.healthcare], about: "The test required for admission into optometry programs in the United States.", image: "OAT-Exam"),
            
            ExamDetails(name: "Praxis Exam", acronym: "Praxis", category: [.education, .topColledgePicks], about: "A series of American teacher certification exams that measure", image: "PRAXIS-Exam"),
            
            ExamDetails(name: "Structural Engineering Exam", acronym: "SE", category: [.engineering], about: "A specialized exam for engineers focusing on the design and safety of structures.", image: "SE-Exam"),
            
            ExamDetails(name: "ITIL Certification Exam", acronym: "ITIL", category: [.technology], about: "ITIL (Information Technology Infrastructure Library) Certification Exam focuses on IT service management, professionalism, and the comprehensive approach that ITIL embodies for aligning IT services with business needs.", image: "ITIL-Exam"),
            
            ExamDetails(name: "PRINCE2 Certification Exam", acronym: "PRINCE2", category: [.business], about: "PRINCE2 (Projects IN Controlled Environments) Certification Exam audio quiz packet focuses on project management, organization, and structure, and reflecting the methodology's focus on process-based approaches for effective project management.", image: "PRINCE2-Exam"),
            
            ExamDetails(name: "SAP Certification Exam", acronym: "SAP", category: [.technology], about: "SAP Certification Exam involves highlighting elements of enterprise resource planning (ERP), business processes, and data analysis, given SAP's role in integrating various business operations and providing data-driven solutions.", image: "SAP-Exam"),
            
            ExamDetails(name: "Google Cloud Certified Exam", acronym: "GCP", category: [.technology, .topCollection], about: "Focuses on testing knowledge of the cutting-edge nature of cloud computing, Google's innovative ecosystem, and the technical expertise required to achieve certification.", image: "GoogleCloud-Exam"),
            
            ExamDetails(name: "Linux Professional Institute Certification", acronym: "LPIC", category: [.technology, .topProfessionalCertification, .topCollection], about: "Certification for Linux system administrators.", image: "LPIC-Exam")
            
            //ExamDetails(name: "Fundamentals of Engineering Exam", acronym: "FE", category: [.engineering], about: "An exam that must be passed to become a licensed engineer in the United States.", image: "SE-Exam"),

        ]
    }
}
