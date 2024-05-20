
Функция codeВводКода(Запрос)
	
	Код = "";
	Для Каждого Параметр Из Запрос.ПараметрыЗапроса Цикл
		
		Если Параметр.Ключ = "code" Тогда
			Код = Параметр.Значение;
		КонецЕсли;
		
	КонецЦикла;	
	
	Обработки.Авторизация.ЗаписатьЗадание(Перечисления.ВидЗаданийАвторизации.ВводКода, Перечисления.СтатусЗаданийАвторизации.Новое, Код);
	
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
	
КонецФункции

Функция loginАвторизация(Запрос)	
	
	Обработки.Авторизация.ЗаписатьЗадание(Перечисления.ВидЗаданийАвторизации.Авторизация, Перечисления.СтатусЗаданийАвторизации.Новое);
	
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;	
	
КонецФункции

Функция anydeskЭнидеск(Запрос)
	
	Обработки.Авторизация.ЗаписатьЗадание(Перечисления.ВидЗаданийАвторизации.Энидеск, Перечисления.СтатусЗаданийАвторизации.Новое);
	
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
КонецФункции
