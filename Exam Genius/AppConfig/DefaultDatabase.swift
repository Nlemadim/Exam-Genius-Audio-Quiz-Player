//
//  DefaultDatabase.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/22/24.
//

import Foundation

struct DefaultDatabase {
    
    static func getAllExamDetails() -> [ExamDetails] {
        [
            ExamDetails(name: "California Bar Exam", acronym: "CBX", category: .legal, about: "A licensure exam for practicing law in California.", image: "BarExam-Exam"),
            ExamDetails(name: "Medical College Admission Test", acronym: "MCAT", category: .science, about: "A standardized exam for prospective medical students in the USA.", image: "MCAT-Exam"),
            ExamDetails(name: "Certified Public Accountant Exam", acronym: "CPA", category: .business, about: "Exam for accounting professionals to become certified public accountants in the USA.", image: "CPA-Exam"),
            ExamDetails(name: "National Council Licensure Examination for Registered Nurses", acronym: "NCLEX-RN", category: .healthcare, about: "A national exam for the licensing of nurses in the USA.", image: "NCLEX-RN-Exam"),
            ExamDetails(name: "Project Management Professional Exam", acronym: "PMP", category: .business, about: "Certification exam for project managers.", image: "PMP-Exam"),
            ExamDetails(name: "Law School Admission Test", acronym: "LSAT", category: .legal, about: "A standardized test for admissions to law schools in the USA.", image: "LSAT-Exam"),
            ExamDetails(name: "CompTIA A+", acronym: "A+", category: .technology, about: "Certification for entry-level computer technicians.", image: "CompTIA-APlus-Exam"),
            ExamDetails(name: "Professional Engineer Exam", acronym: "PE", category: .engineering, about: "Licensure exam for engineers to become professionally certified.", image: "PE-Exam"),
            ExamDetails(name: "Certified Financial Planner Exam", acronym: "CFP", category: .finance, about: "Certification exam for financial planners.", image: "CFP-Exam"),
            ExamDetails(name: "Real Estate Licensing Exam", acronym: "RELE", category: .business, about: "Licensing exam for real estate agents.", image: "RealEstate-Exam"),
            ExamDetails(name: "Architect Registration Exam", acronym: "ARE", category: .engineering, about: "Licensing exam for architects.", image: "ArchitectRegistration-Exam"),
            ExamDetails(name: "Series 7 Exam", acronym: "Series 7", category: .finance, about: "Qualification exam for stockbrokers in the USA.", image: "Series7-Exam"),
            ExamDetails(name: "Graduate Record Examinations", acronym: "GRE", category: .education, about: "A standardized test for admissions to graduate schools.", image: "GRE-Exam"),
            ExamDetails(name: "Test of English as a Foreign Language", acronym: "TOEFL", category: .language, about: "A standardized test to measure the English language ability of non-native speakers.", image: "TOEFL-Exam"),
            ExamDetails(name: "Graduate Management Admission Test", acronym: "GMAT", category: .business, about: "A test for admissions to business schools.", image: "GMAT-Exam"),
            ExamDetails(name: "Chartered Financial Analyst Exam", acronym: "CFA", category: .finance, about: "A professional credential offered internationally by the American-based CFA Institute to investment and financial professionals.", image: "CFA-Exam"),
            ExamDetails(name: "Cisco Certified Network Associate Exam", acronym: "CCNA", category: .technology, about: "A certification for network administrators, supporting and configuring IP networks.", image: "CCNA-Exam"),
            ExamDetails(name: "Bar Professional Training Course", acronym: "BPTC", category: .legal, about: "Training course in England and Wales that bridges the gap between academic legal study and being a practicing barrister.", image: "BPTC-Exam"),
            ExamDetails(name: "Medical Council of Canada Qualifying Exam", acronym: "MCCQE", category: .healthcare, about: "A two-part examination that assesses the competency of medical graduates, allowing them to practice medicine in Canada.", image: "MCCQE-Exam"),
            ExamDetails(name: "Certified Ethical Hacker Exam", acronym: "CEH", category: .technology, about: "Certification for IT professionals seeking to prove their skills in ethical hacking and penetration testing.", image: "CEH-Exam"),
            ExamDetails(name: "Certified Information Systems Security Professional Exam", acronym: "CISSP", category: .technology, about: "An advanced-level certification for IT pros serious about careers in information security.", image: "CISSP-Exam"),
            ExamDetails(name: "Certified ScrumMaster Exam", acronym: "CSM", category: .business, about: "Certification for project managers in agile development methodology to lead Scrum teams.", image: "CSM-Exam"),
            ExamDetails(name: "Certified Six Sigma Green Belt Exam", acronym: "CSSGB", category: .business, about: "Certification that recognizes professionals who are skilled in facilitating team activities within Six Sigma.", image: "CSSGB-Exam"),
            ExamDetails(name: "Certified Information Systems Auditor Exam", acronym: "CISA", category: .technology, about: "Certification for information technology audit professionals.", image: "CISA-Exam"),
            ExamDetails(name: "National Counselor Examination for Licensure and Certification", acronym: "NCE", category: .healthcare, about: "A certification for counselors in the U.S. that assesses knowledge and skills to practice safely and effectively.", image: "NCE-Exam"),
            ExamDetails(name: "National Clinical Mental Health Counseling Examination", acronym: "NCMHCE", category: .healthcare, about: "An examination that tests for knowledge in the field of mental health counseling.", image: "NCMHCE-Exam"),
            ExamDetails(name: "Swift Programming Language", acronym: "Swift", category: .technology, about: "Certification for developers in the Swift programming language, used for iOS and macOS applications.", image: "SwiftProgramming-Exam"),
            ExamDetails(name: "ACT Exam", acronym: "ACT", category: .education, about: "A standardized test for high school achievement and college admissions in the United States.", image: "ACT-Exam"),
            ExamDetails(name: "SAT Exam", acronym: "SAT", category: .education, about: "A standardized test widely used for college admissions in the United States.", image: "SAT-Exam"),
            ExamDetails(name: "Advanced Placement Exams", acronym: "AP", category: .education, about: "Exams that offer high school students the opportunity to earn college credit, advanced placement, or both, in various subject areas.", image: "AP-Exams"),
            ExamDetails(name: "Dental Admission Test", acronym: "DAT", category: .healthcare, about: "A standardized test to assess the qualification of dental school applicants in the United States and Canada.", image: "DAT-Exam"),
            ExamDetails(name: "Optometry Admission Test", acronym: "OAT", category: .healthcare, about: "The test required for admission into optometry programs in the United States.", image: "OAT-Exam"),
            ExamDetails(name: "Pharmacy College Admission Test", acronym: "PCAT", category: .healthcare, about: "A computer-based standardized test that helps to identify qualified applicants to pharmacy colleges.", image: "PCAT-Exam"),
            ExamDetails(name: "Veterinary Technician National Exam", acronym: "VTNE", category: .healthcare, about: "A credentialing examination for veterinary technicians.", image: "VTNE-Exam"),
            ExamDetails(name: "Praxis Exam", acronym: "Praxis", category: .education, about: "A series of American teacher certification exams that measure", image: "OAT-Exam"),ExamDetails(name: "Fundamentals of Engineering Exam", acronym: "FE", category: .engineering, about: "An exam that must be passed to become a licensed engineer in the United States.", image: "FE-Exam"),
            ExamDetails(name: "Structural Engineering Exam", acronym: "SE", category: .engineering, about: "A specialized exam for engineers focusing on the design and safety of structures.", image: "SE-Exam"),
            ExamDetails(name: "ITIL Certification Exam", acronym: "ITIL", category: .technology, about: "Certification for IT service management based on ITIL practices.", image: "ITIL-Exam"),
            ExamDetails(name: "PRINCE2 Certification Exam", acronym: "PRINCE2", category: .business, about: "A process-based method for effective project management.", image: "PRINCE2-Exam"),
            ExamDetails(name: "SAP Certification Exam", acronym: "SAP", category: .technology, about: "Certification for professionals working with SAP software solutions.", image: "SAP-Exam"),
            ExamDetails(name: "AWS Certified Solutions Architect Exam", acronym: "AWS CSA", category: .technology, about: "Certification for individuals designing distributed systems on AWS.", image: "AWS-Exam"),
            ExamDetails(name: "Google Cloud Certified Exam", acronym: "GCP", category: .technology, about: "Certification for individuals using Google Cloud technologies.", image: "GoogleCloud-Exam"),
            ExamDetails(name: "Microsoft Azure Fundamentals Exam", acronym: "Azure Fundamentals", category: .technology, about: "Certification covering basic Azure concepts and services.", image: "Azure-Exam"),
            ExamDetails(name: "Cybersecurity Analyst (CySA+)", acronym: "CySA+", category: .technology, about: "Certification for IT cybersecurity analysts focusing on threat detection and response.", image: "CySA-Exam"),
            ExamDetails(name: "CompTIA Network+", acronym: "Network+", category: .technology, about: "Certification for networking professionals.", image: "NetworkPlus-Exam"),
            ExamDetails(name: "CompTIA Security+", acronym: "Security+", category: .technology, about: "Certification dealing with core cybersecurity skills.", image: "SecurityPlus-Exam"),
            ExamDetails(name: "Linux Professional Institute Certification (LPIC)", acronym: "LPIC", category: .technology, about: "Certification for Linux system administrators.", image: "LPIC-Exam"),
            ExamDetails(name: "Certified Cloud Security Professional (CCSP)", acronym: "CCSP", category: .technology, about: "Certification for IT and information security leaders in cloud security.", image: "CCSP-Exam"),
            ExamDetails(name: "Project Management Professional (PMP)", acronym: "PMP", category: .business, about: "Internationally recognized professional certification for project managers.", image: "PMP-Exam"),
            ExamDetails(name: "Certified Supply Chain Professional (CSCP)", acronym: "CSCP", category: .business, about: "Certification for supply chain management professionals.", image: "CSCP-Exam"),
            ExamDetails(name: "Certified in Production and Inventory Management (CPIM)", acronym: "CPIM", category: .business, about: "Certification for professionals in production and inventory management.", image: "CPIM-Exam"),
            ExamDetails(name: "Certified Healthcare Financial Professional (CHFP)", acronym: "CHFP", category: .finance, about: "Certification focusing on financial strategies in healthcare.", image: "CHFP-Exam"),
            ExamDetails(name: "Certified Management Accountant (CMA)", acronym: "CMA", category: .finance, about: "Certification for accountants and financial professionals in business.", image: "CMA-Exam"),
            ExamDetails(name: "Certified Public Accountant (CPA)", acronym: "CPA", category: .finance, about: "Licensure for accountants to practice public accounting in the United States.", image: "CPA-Exam"),
            ExamDetails(name: "Certified Internal Auditor (CIA)", acronym: "CIA", category: .finance, about: "Certification for professionals who conduct internal audits.", image: "CIA-Exam")
        ]
    }
}


