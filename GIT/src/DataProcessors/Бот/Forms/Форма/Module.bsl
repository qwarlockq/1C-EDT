
//////////////////////////////////////////
/// СОБЫТИЯ ФОРМЫ

&НаКлиенте
Процедура ПолеХТМЛПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	 	
	//ДивКнопка = Элемент.Документ.getElementById("s1"); //Кнопка обучить
	
	//ДивМаксКоличество = Элемент.Документ.getElementById("nonFavouriteTroops");
	
	//Элемент.Документ.querySelector("input[name='t5']").value Получение поля по имени
	//Элемент.Документ.querySelector("#nonFavouriteTroops .troop5 .cta a").text Получить максимальное значение из ссылки
	//Элемент.Документ.querySelector("button[value^='Улучшить до уровня']") - Поиск кнопки по value
	
		
	//ДивКнопка = Элементы.Документ.getElementById("s1"); //Кнопка обучить
	//
	////ДивКнопка.setAttribute("onclick", "alert('Координаты');");	
	//ДивКнопка.click();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ) 	
	
	ТекущаяСтраница   = "https://ts9.x1.europe.travian.com/dorf2.php";	 		
	ЗапуститьЗадание  = Истина;
	ЧастотаВыполнения = 30;
	
	УправлениеОформлением();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеХТМЛДокументСформирован(Элемент)
	
	ТекущаяСтраница = Элемент.Документ.URL;
	
	Если Не ЗапуститьЗадание Тогда
		ЗапуститьЗадание = Истина;
		Возврат;
	КонецЕсли;
	
	Если БотЗапущен Тогда
		ОбработкаОчереди(Ложь);	
	КонецЕсли;
	
КонецПроцедуры


//////////////////////////////////////////
/// КНОПКИ

&НаКлиенте
Процедура ЗапуститьБота(Команда)
		
	Если БотЗапущен Тогда
		ОтключитьОбработчикОжидания("ЗапуститьБотаДляПереходаПоСсылке");
	Иначе
		ПодключитьОбработчикОжидания("ЗапуститьБотаДляПереходаПоСсылке", ЧастотаВыполнения);
	КонецЕсли;
	
	БотЗапущен = Не БотЗапущен;
	
	УправлениеОформлением();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	Для Каждого Строка Из ОчередьЗадач Цикл
		Строка.Отметка = Истина
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеОтметки(Команда)
	
	Для Каждого Строка Из ОчередьЗадач Цикл
		Строка.Отметка = Ложь
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущееВремя(Команда)
	
	Для Каждого Строка Из ОчередьЗадач Цикл
		
		Если Строка.Отметка Тогда
			Строка.Время = ТекущаяДата();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчередьЗадачДействиеПриИзменении(Элемент)
	
	ТекДанные = Элементы.ОчередьЗадач.ТекущиеДанные;
	
	Если ТекДанные.Действие = ПредопределенноеЗначение("Перечисление.Задания.ОбучитьЮнитов") Тогда
		ДобавитьСтрокуСПереходом();
	КонецЕсли;
	
КонецПроцедуры


//////////////////////////////////////////
/// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ/ФУНКЦИИ

&НаКлиенте 
Процедура ЗапуститьБотаДляПереходаПоСсылке()
	
	ЗапуститьЗадание = Истина;
	
	ОбработкаОчереди(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОчереди(ПереходПоСсылке = Истина)
	
	Для Каждого Задача Из ОчередьЗадач Цикл
		
		Если Задача.Выполнено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Задача.Время <= ТекущаяДата() Тогда
			
			Если ПереходПоСсылке Тогда
				
				Если Задача.Действие = ПредопределенноеЗначение("Перечисление.Задания.Набег") Тогда
					ТекущаяСтраница = ПолучитьАдресОтправкиВойск();
				Иначе
					ТекущаяСтраница = ПолучитьАдрес(Задача.Постройка);				
				КонецЕсли;   				
				
			Иначе
				
				ВыполнитьДействие(Задача);				
				
			КонецЕсли;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;   	 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействие(Задача)
	
	Попытка
		
		Если Задача.Действие = ПредопределенноеЗначение("Перечисление.Задания.ОбучитьЮнитов") Тогда
			ОбучитьЮнитов(Задача);
		ИначеЕсли Задача.Действие = ПредопределенноеЗначение("Перечисление.Задания.УлучшитьПостройку") Тогда
			УлучшитьЗдание(Задача);
		ИначеЕсли Задача.Действие = ПредопределенноеЗначение("Перечисление.Задания.ПерейтиНаСтраницу") Тогда
			ПерейтиНаСтраницу(Задача);
		ИначеЕсли Задача.Действие = ПредопределенноеЗначение("Перечисление.Задания.Набег") Тогда
			СовершитьНабег(Задача);
		КонецЕсли;
		
	Исключение
		
		ТекущаяСтраница = "https://ts9.x1.europe.travian.com/dorf2.php";		
		Сообщить(ОписаниеОшибки());
		
	КонецПопытки;
	
	ЗапуститьЗадание = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбучитьЮнитов(Задача)
	
	ИмяПоля = ПолучитьИмяПоля(Задача.ТипВойск);
	
	ПолеКоличество = Элементы.ПолеХТМЛ.Документ.querySelector("input[name='" + ИмяПоля + "']");
	ПолеКоличество.value = Задача.Количество;
	
	КнопкаОбучить = Элементы.ПолеХТМЛ.Документ.getElementById("s1");
	
	Если КнопкаОбучить <> Неопределено Тогда
		КнопкаОбучить.click();
		Задача.Выполнено = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УлучшитьЗдание(Задача)
	
	КнопкаУлучшить = Элементы.ПолеХТМЛ.Документ.querySelector("button[value^='Улучшить до уровня']");
	
	Если КнопкаУлучшить <> Неопределено Тогда
		КнопкаУлучшить.click();
		Задача.Выполнено = Истина;
	Иначе
		ТекущаяСтраница = "https://ts9.x1.europe.travian.com/dorf2.php";
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницу(Задача)
	
	ТекущаяСтраница = ПолучитьАдрес(Задача.Постройка);
	
	Задача.Выполнено = Истина;
	
	ЗапуститьЗадание = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СовершитьНабег(Задача)
	
	ИмяПоляКоличество = "troops[0][" + ПолучитьИмяПоля(Задача.ТипВойск) + "]";	
	ПолеКоличество 	  = Элементы.ПолеХТМЛ.Документ.querySelector("input[name='" + ИмяПоляКоличество + "']");
	ПолеКоличество.value = Задача.Количество;
	
	ЗначениеX = ПолучитьКоординату(Задача.Постройка, "X");
	ПолеX = Элементы.ПолеХТМЛ.Документ.getElementById("xCoordInput");
	ПолеX.value = ЗначениеX;
	
	ЗначениеY = ПолучитьКоординату(Задача.Постройка, "Y");
	ПолеY = Элементы.ПолеХТМЛ.Документ.getElementById("yCoordInput");
	ПолеY.value = ЗначениеY;
	
	КнопкаОбучить = Элементы.ПолеХТМЛ.Документ.getElementById("btn_ok");
	
	Если КнопкаОбучить <> Неопределено Тогда
		КнопкаОбучить.click();
		Задача.Выполнено = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеОформлением()
	
	Если БотЗапущен Тогда
		Элементы.ФормаЗапуститьБота.Заголовок = "Остановить бота";
	Иначе
		Элементы.ФормаЗапуститьБота.Заголовок = "Запустить бота";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдрес(Постройка)
	Возврат Постройка.Адрес;
КонецФункции

&НаСервере
Функция ПолучитьИмяПоля(ТипВойск)
	Возврат ТипВойск.ИмяПоля;	
КонецФункции

&НаСервере
Функция ДобавитьСтрокуСПереходом()
	
	НоваяСтрока = ОчередьЗадач.Добавить();
	
	НоваяСтрока.Постройка = Справочники.Постройки.ЦентрДеревни;
	НоваяСтрока.Действие  = Перечисления.Задания.ПерейтиНаСтраницу;
	
КонецФункции

&НаСервере
Функция ПолучитьАдресОтправкиВойск()
	Возврат Константы.АдресОтправкиВойск.Получить();
КонецФункции
	
&НаСервере
Функция ПолучитьКоординату(Постройка, Координата)
	Возврат Постройка[Координата];
КонецФункции