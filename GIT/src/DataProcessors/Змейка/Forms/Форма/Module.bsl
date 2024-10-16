
/////////////////////////////////////////
/// УСТАНОВКА ПАРАМЕТРОВ

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьТаблицуЛидеров();
	  	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьПараметры()
	
	КоличествоОчков = 0;
	
	СкоростьИгры = 0.6;
	
	// Отрисуем поле
	Поле = ВывестиПоле();	
	
	Граница = ГраницыПоля.Добавить();	
	Граница.X = Поле.ШиринаТаблицы;
	Граница.Y = Поле.ВысотаТаблицы;
	
	// Определим змейку
	Змейка.Очистить();
	
	НачальнаяТочка = Змейка.Добавить();
	
	НачальнаяТочка.X = 3;
	НачальнаяТочка.Y = 3;
	
	Направление = "Вправо";        	
	
	// Выведем яблоко
	НарисоватьЯблоко();
	
	// Выведем змейку
	НарисоватьГолову(); 	 		
	
	ОбновитьТаблицуЛидеров();
	
	ПривязатьКлавиши();
		
	// ЗаLOOPим процедуру
	ПодключитьОбработчикОжидания("ЗацикленнаяПроцедура", СкоростьИгры, Истина);

КонецПроцедуры

&НаСервере
Функция ВывестиПоле()
	
	ТабДок = Новый ТабличныйДокумент;
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Макет = ОбработкаОбъект.ПолучитьМакет("Поле"); 
	
	ТабДок.Вывести(Макет);
	
	Возврат ТабДок;
	
КонецФункции

&НаСервере
Процедура УстановитьСложность()
	
	Если КоличествоОчков = 5 Тогда
		СкоростьИгры = 0.4;
	ИначеЕсли КоличествоОчков = 10 Тогда
		СкоростьИгры  = 0.2;
	ИначеЕсли КоличествоОчков = 20 Тогда
		СкоростьИгры = 0.1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПривязатьКлавиши()
	
	// Привяжем клавиши самостоятельно, чтобы они не мешались при вводе имени
	Элементы.НаправлениеВверх.СочетаниеКлавиш 	= Новый СочетаниеКлавиш(Клавиша.W);	
	Элементы.НаправлениеВниз.СочетаниеКлавиш 	= Новый СочетаниеКлавиш(Клавиша.S);
	Элементы.НаправлениеВлево.СочетаниеКлавиш 	= Новый СочетаниеКлавиш(Клавиша.A);
	Элементы.НаправлениеВправо.СочетаниеКлавиш 	= Новый СочетаниеКлавиш(Клавиша.D);
	
КонецПроцедуры


/////////////////////////////////////////
/// LOOP ПРОЦЕДУРА

&НаКлиенте
Процедура ЗацикленнаяПроцедура()
	
	// Двигаем змейку
	ТекущаяГолова = Змейка[Змейка.Количество() - 1];
	 	
	Если Направление = "Вправо" Тогда
		НоваяГоловаX = ТекущаяГолова.X + 1;
		НоваяГоловаY = ТекущаяГолова.Y;
	ИначеЕсли Направление = "Влево" Тогда
		НоваяГоловаX = ТекущаяГолова.X - 1;
		НоваяГоловаY = ТекущаяГолова.Y;
	ИначеЕсли Направление = "Вверх" Тогда
		НоваяГоловаX = ТекущаяГолова.X;
		НоваяГоловаY = ТекущаяГолова.Y - 1;
	ИначеЕсли Направление = "Вниз" Тогда
		НоваяГоловаX = ТекущаяГолова.X;
		НоваяГоловаY = ТекущаяГолова.Y + 1;
	КонецЕсли;
	
	// Проверяем врезалась ли змейка в стену или в саму себя 
	КонецИгры	 = Ложь;
	УдалитьХвост = Истина; // По-умолчанию удаляем хвост всегда
	
	Отбор = Новый Структура("X, Y", НоваяГоловаX, НоваяГоловаY);
	Если (НоваяГоловаX > ГраницыПоля[0].X Или НоваяГоловаX <= 0) Или (НоваяГоловаY > ГраницыПоля[0].Y Или НоваяГоловаY <= 0) Тогда
		
		КонецИгры = Истина;
		
	Иначе
		
		НайденныеСтроки = Змейка.НайтиСтроки(Отбор);
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			КонецИгры = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	НоваяГолова = Змейка.Добавить();
	
	НоваяГолова.X = НоваяГоловаX;
	НоваяГолова.Y = НоваяГоловаY;
	
	// Проверим съела ли она яблоко
	НайденныеСтроки = Яблоко.НайтиСтроки(Отбор);
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		КоличествоОчков = КоличествоОчков + 1;
		УдалитьХвост = Ложь;
		НарисоватьЯблоко();
	КонецЕсли;       	
	
	Если КонецИгры Тогда
		
		ОтключитьОбработчикОжидания("ЗацикленнаяПроцедура");
		
		КонецИгры();		
		ЗадатьВопрос();		
		
	Иначе				
		
		НарисоватьГолову();	
		УдалитьХвост(УдалитьХвост);
		
		УстановитьСложность();
		
		ПодключитьОбработчикОжидания("ЗацикленнаяПроцедура", СкоростьИгры, Истина);
		
	КонецЕсли;		
	
КонецПроцедуры


/////////////////////////////////////////
/// ЯБЛОКО

&НаКлиенте
Процедура НарисоватьЯблоко()
	
	Генератор = Новый ГенераторСлучайныхЧисел();
	
	// Удалим яблоко с поля
	Если Яблоко.Количество() > 0 Тогда
		
		ТекЯблоко = Яблоко[0];
		
		Ячейка = Поле.Область(ТекЯблоко.Y, ТекЯблоко.X);
		Ячейка.ЦветФона = WebЦвета.Белый;
		Ячейка.Текст = "";
		
		Яблоко.Очистить();
		
	КонецЕсли;
	
	// Выведем новое яблоко
	НовоеЯблоко = Яблоко.Добавить();
	
	Пока Истина Цикл
		
		НовоеЯблоко.X = Генератор.СлучайноеЧисло(1, ГраницыПоля[0].X);
		НовоеЯблоко.Y = Генератор.СлучайноеЧисло(1, ГраницыПоля[0].Y);
		              		
		// Проверим, что яблоко не заспавнилось в змейке
		Отбор = Новый Структура("X, Y", НовоеЯблоко.X, НовоеЯблоко.Y);
		
		НайденныеСтроки = Змейка.НайтиСтроки(Отбор);
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			Продолжить;
		Иначе
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Ячейка = Поле.Область(НовоеЯблоко.Y, НовоеЯблоко.X);		
	Ячейка.Текст = "Х";
	
КонецПроцедуры


/////////////////////////////////////////
/// ДВИЖЕНИЕ ЗМЕЙКИ 

&НаКлиенте
Процедура НарисоватьГолову()
	
	Голова = Змейка[Змейка.Количество() - 1];
	
	Ячейка = Поле.Область(Голова.Y, Голова.X);		
	Ячейка.ЦветФона = WebЦвета.ЗеленаяЛужайка;	
	
	Если Направление = "Вправо" Тогда
		Ячейка.Текст 	= "〉";
	ИначеЕсли Направление = "Влево" Тогда
		Ячейка.Текст 	= "〈";
	ИначеЕсли Направление = "Вверх" Тогда
		Ячейка.Текст 	= "︿";
	ИначеЕсли Направление = "Вниз" Тогда
		Ячейка.Текст 	= "﹀";
	КонецЕсли;	
	 	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьХвост(УдалитьХвост)
	
	Хвост = Змейка[0];
	
	Если УдалитьХвост Тогда		
		
		Ячейка = Поле.Область(Хвост.Y, Хвост.X);
		Ячейка.ЦветФона = WebЦвета.Белый;
		Ячейка.Текст = "";
		
		Змейка.Удалить(Хвост);
		
	КонецЕсли; 
	
	Для Каждого Сегмент Из Змейка Цикл
		
		Голова = Змейка[Змейка.Количество() - 1];
		
		// Костыль, хз как по-другому очищать всё, кроме головы )
		Если Не Сегмент.X = Голова.X Или Не Сегмент.Y = Голова.Y Тогда
			
			Ячейка = Поле.Область(Сегмент.Y, Сегмент.X);
			
			Ячейка.Текст = "";
			
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры


/////////////////////////////////////////
/// СМЕНА НАПРАВЛЕНИЯ

&НаКлиенте
Процедура НаправлениеВверх(Команда)
	Направление = "Вверх";
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеВниз(Команда)
	Направление = "Вниз";
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеВправо(Команда)
	Направление = "Вправо";
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеВлево(Команда)
	Направление = "Влево";
КонецПроцедуры


/////////////////////////////////////////
/// ВЫИГРЫШ/ПРОИГРЫШ

&Наклиенте
Процедура КонецИгры()
	
	ЗаписатьВТаблицуЛидеров();	
	
	// Если текущее количество очков рекордное, то выведем сообщение
	ЭтоРекорд = Истина;	
	Для Каждого Строка Из ТаблицаЛидеров Цикл
		
		Если КоличествоОчков <= Строка.КоличествоОчков Тогда
			ЭтоРекорд = Ложь;
		КонецЕсли;
		
	КонецЦикла;	
	
	ОбновитьТаблицуЛидеров();
	
КонецПроцедуры

&НаКлиенте 
Процедура ЗадатьВопрос()
		
	Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопрос", ЭтотОбъект); // Прописываем название процедуры-обработчика.	
	
	ПоказатьВопрос(Оповещение, "Хорошая попытка! Количество очков: " + КоличествоОчков + ". Попробуем ещё?", РежимДиалогаВопрос.ДаНет, 0,
					КодВозвратаДиалога.Да, "Конец игры");
					
	Если ЭтоРекорд Тогда
		ПоказатьПредупреждение(Неопределено, "ЭТО НОВЫЙ РЕКОРД!");
	КонецЕсли;
	
КонецПроцедуры
				
&НаКлиенте 
Процедура ПослеОтветаНаВопрос(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗадатьПараметры();
	Иначе
		Закрыть();
	КонецЕсли;   
	
КонецПроцедуры


/////////////////////////////////////////
/// КНОПКИ

&НаКлиенте
Процедура Старт(Команда)

	Если ЗначениеЗаполнено(Игрок) Тогда

		Элементы.Страницы.ТекущаяСтраница 	= Элементы.СтраницаОсновная;
		ЭтаФорма.Заголовок					= "Змейка (Игрок " + Игрок + ")";

		ЗадатьПараметры();		

	Иначе

		ПоказатьПредупреждение(Неопределено, "Введите имя игрока.");

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачатьЗаново(Команда)
	ЗадатьПараметры();
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьИгру(Команда)
	Закрыть();
КонецПроцедуры

/////////////////////////////////////////
/// ТАБЛИЦА ЛИДЕРОВ

&НаСервере
Процедура ЗаписатьВТаблицуЛидеров()
	
	РегистрыСведений.ТаблицаЛидеров.ЗаписатьВТаблицуЛидеров(Игрок, Перечисления.Игры.Змейка, КоличествоОчков);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуЛидеров()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 10
		|	ТаблицаЛидеров.Период КАК ДатаИгры,
		|	ТаблицаЛидеров.Игрок,
		|	ТаблицаЛидеров.КоличествоОчков КАК КоличествоОчков
		|ИЗ
		|	РегистрСведений.ТаблицаЛидеров КАК ТаблицаЛидеров
		|
		|УПОРЯДОЧИТЬ ПО
		|	КоличествоОчков УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	ТаблицаЛидеров.Загрузить(РезультатЗапроса);	
	
КонецПроцедуры
