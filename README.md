Общая картина такая:
Мы пишем программу управления каталогом книг. серва мы сканируем папку, где свалены (или разложены по порядку) файлы книг в форматах, pdf, fb2, docx, ebook И так далее. Из каждой книги извлекаются метаданные и обложка. Если обложки нет - создаём. Далее эти данные (TBookMetadata) складываются вместе с обложкой (cover.jpg) в папку, название которой генерим из заголовка книги, а фиксированная часть их (TBookBrief) отправляется в базу данных в оперативке (массив? Список? Что-то ещё?).
Далее обычная работа с базой через графическую оболочку. В качестве образца берём calibre2.
Можем повесить на книгу тэги, серии, категории, стандартизовать имя авторов. Вот такая задача
Инструменты: Object Pascal, Git.
