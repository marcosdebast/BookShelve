//
//  BookSampler.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 17/04/24.
//

import Foundation

struct BookSampler {
    static private(set) var allBooks: [Book] = [
        //Book(id: "HestSXO362YC", title: "The Great Gatsby", descriptionText: "Set in the Roaring Twenties, this novel explores themes of decadence, idealism, and the American Dream through the lens of narrator Nick Carraway, who becomes entangled in the lives of his wealthy neighbor Jay Gatsby and his cousin Daisy Buchanan.", authors: ["F. Scott Fitzgerald"], publishedDate: Date.dateBySetting(year: 1925), industryIdentifiers: [], pages: 180, imageLinks: ImageLink(thumbnail: "https://m.media-amazon.com/images/I/81xjr9TiTtL._SL1500_.jpg"), language: "EN"),

        //Book(id: "kotPYEqx7kMC", title: "1984", descriptionText: "A dystopian novel set in a totalitarian society, where the government, led by the enigmatic Big Brother, exercises complete control over its citizens, surveilling their every move and even their thoughts.", authors: ["George Orwell"], publishedDate: Date.dateBySetting(year: 1949), industryIdentifiers: [], pages: 328, imageLinks: ImageLink(thumbnail: "https://m.media-amazon.com/images/I/61M9jDcsl2L._SL1000_.jpg"), language: "EN"),

        //Book(id: "mdnrlnf9IGwC", title: "Pride and Prejudice", descriptionText: "This classic romance novel follows the tumultuous relationship between the headstrong Elizabeth Bennet and the proud Mr. Darcy against the backdrop of early 19th-century England's social hierarchy.", authors: ["Jane Austen"], publishedDate: Date.dateBySetting(year: 1813), industryIdentifiers: [], pages: 279, imageLinks: ImageLink(thumbnail: "https://m.media-amazon.com/images/I/91FldvTHNvL._SL1500_.jpg"), language: "EN"),

        //Book(id: "j--EMdEfmbkC", title: "The Catcher in the Rye", descriptionText: "Narrated by disillusioned teenager Holden Caulfield, this novel explores themes of alienation, identity, and adolescence as Holden embarks on a journey through New York City following his expulsion from prep school.", authors: ["J.D. Salinger"], publishedDate: Date.dateBySetting(year: 1951), industryIdentifiers: [], pages: 234, imageLinks: ImageLink(thumbnail: "https://m.media-amazon.com/images/I/71nXPGovoTL._SL1500_.jpg"), language: "EN"),

        //Book(id: "dVeengEACAAJ", title: "The Hobbit", descriptionText: "Bilbo Baggins, a hobbit of the Shire, is swept into an epic quest by the wizard Gandalf and a company of dwarves to reclaim the Lonely Mountain and its treasure from the dragon Smaug.", authors: ["J.R.R. Tolkien"], publishedDate: Date.dateBySetting(year: 1937), industryIdentifiers: [], pages: 310, imageLinks: ImageLink(thumbnail: "https://m.media-amazon.com/images/I/71V2v2GtAtL._SL1500_.jpg"), language: "EN"),
        
        //Book(id: "fo4rzdaHDAwC", title: "Harry Potter and the Sorcerer's Stone", descriptionText: "Join young wizard Harry Potter as he discovers his magical heritage and begins his journey at Hogwarts School of Witchcraft and Wizardry, where he uncovers dark secrets and faces the infamous dark wizard, Voldemort.", authors: ["J.K. Rowling"], publishedDate: Date.dateBySetting(year: 1997), industryIdentifiers: [], pages: 223, imageLinks: ImageLink(thumbnail: "https://m.media-amazon.com/images/I/71RVt35ZAbL._SL1200_.jpg"), language: "EN", started: false),
        
        //Book(id: "1o7D0m_osFEC", title: "Harry Potter and the Chamber of Secrets", descriptionText: "Follow Harry Potter and his friends as they investigate a mysterious series of attacks on students at Hogwarts, all while battling their own personal struggles and uncovering the secrets of the Chamber of Secrets.", authors: ["J.K. Rowling"], publishedDate: Date.dateBySetting(year: 1998), industryIdentifiers: [], pages: 251, imageLinks: ImageLink(thumbnail: "https://m.media-amazon.com/images/I/71MUiF4iVzL._AC_SL1000_.jpg"), language: "EN"),

        //Book(id: "Sm5AKLXKxHgC", title: "Harry Potter and the Prisoner of Azkaban", descriptionText: "In the third installment of the series, Harry Potter returns to Hogwarts for his third year, where he encounters the infamous convict Sirius Black and learns the truth about his past while facing the chilling Dementors.", authors: ["J.K. Rowling"], publishedDate: Date.dateBySetting(year: 1999), industryIdentifiers: [], pages: 317, imageLinks: ImageLink(thumbnail: "https://m.media-amazon.com/images/I/812CcFkEPCL._SL1200_.jpg"), language: "EN"),
        
        //Book(id: "etukl7GfrxQC", title: "Harry Potter and the Goblet of Fire", descriptionText: "As Harry Potter competes in the prestigious Triwizard Tournament, he finds himself thrust into a dangerous game of magical challenges and political intrigue, all while Voldemort's dark forces begin to rise once again.", authors: ["J.K. Rowling"], publishedDate: Date.dateBySetting(year: 2000), industryIdentifiers: [], pages: 636, imageLinks: ImageLink(thumbnail: "https://m.media-amazon.com/images/I/71ykU-RQ0nL._AC_SL1000_.jpg"), language: "EN")
    ]
    
    static private(set) var ongoingBooks: [Book] = [
        Book(id: "fo4rzdaHDAwC", title: "Harry Potter and the Sorcerer's Stone", descriptionText: "Join young wizard Harry Potter as he discovers his magical heritage and begins his journey at Hogwarts School of Witchcraft and Wizardry, where he uncovers dark secrets and faces the infamous dark wizard, Voldemort.", authors: ["J.K. Rowling"], publishedDate: Date.dateBySetting(year: 1997), industryIdentifiers: [], pages: 223, currentPage: 2, imageLinks: ImageLink(thumbnail: "https://m.media-amazon.com/images/I/71RVt35ZAbL._SL1200_.jpg"), language: "EN", started: true),
        
        Book(id: "1o7D0m_osFEC", title: "Harry Potter and the Chamber of Secrets", descriptionText: "Follow Harry Potter and his friends as they investigate a mysterious series of attacks on students at Hogwarts, all while battling their own personal struggles and uncovering the secrets of the Chamber of Secrets.", authors: ["J.K. Rowling"], publishedDate: Date.dateBySetting(year: 1998), industryIdentifiers: [], pages: 251, currentPage: 1, imageLinks: ImageLink(thumbnail: "https://m.media-amazon.com/images/I/71MUiF4iVzL._AC_SL1000_.jpg"), language: "EN", started: true),
    ]
}
