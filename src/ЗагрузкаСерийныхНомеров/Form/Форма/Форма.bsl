﻿#Область ОбработчикиСобытийФормы



#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.Фильтр = "Файл Excel(*.xls;*.xlsx)|*.xls;*.xlsx";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл Excel для загрузки";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Объект.ПутьКФайлу = ДиалогОткрытияФайла.ПолноеИмяФайла;
		ЗагрузитьДанныеФайлаВТабличныйДокумент();
	КонецЕсли;
	УстановитьДоступностьЗагрузкиСН();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДанныеФайла



#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьСНВБД(Команда)

	КоличествоСтрок = Объект.СерийныеНомера.Количество()-1;
	Для Индекс = 0 По КоличествоСтрок Цикл
		ЗагрузитьСНВБДНаСервере(Индекс);
		УстановитьСостояниеЗагрузки(ПроцентВыполнения(КоличествоСтрок, Индекс), Ложь)
	КонецЦикла;
	ЗаписатьСНСервер();
	УстановитьДоступностьЗагрузкиСН(Ложь);
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Обработка данных закончена. Обработано %1 позиций.'"), КоличествоСтрок);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьСНСервер()

	Если ДанныеДляЗаписиСН.Количество() Тогда
		СНДляНабораЗаписей = РеквизитФормыВЗначение("ДанныеДляЗаписиСН");
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗагруженныеСН.Номенклатура,
		|	ЗагруженныеСН.Контейнер,
		|	ЗагруженныеСН.СерийныйНомер,
		|	ЗагруженныеСН.СерийныйНомерПо,
		|	ЗагруженныеСН.ПартияНоменклатуры
		|ПОМЕСТИТЬ ЗагруженныеСН
		|ИЗ
		|	&ЗагруженныеСН КАК ЗагруженныеСН
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗагруженныеСН.Номенклатура,
		|	ЗагруженныеСН.Контейнер,
		|	ЗагруженныеСН.СерийныйНомер,
		|	ЗагруженныеСН.СерийныйНомерПо,
		|	ЗагруженныеСН.ПартияНоменклатуры
		|ИЗ
		|	ЗагруженныеСН КАК ЗагруженныеСН
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.усСерийныеНомера КАК усСерийныеНомера
		|		ПО ЗагруженныеСН.Номенклатура = усСерийныеНомера.Номенклатура
		|			И ЗагруженныеСН.Контейнер = усСерийныеНомера.Контейнер
		|			И (ЗагруженныеСН.СерийныйНомер ПОДОБНО усСерийныеНомера.СерийныйНомер)
		|			И ЗагруженныеСН.СерийныйНомерПо = усСерийныеНомера.СерийныйНомерПо
		|			И ЗагруженныеСН.ПартияНоменклатуры = усСерийныеНомера.ПартияНоменклатуры
		|ГДЕ
		|	усСерийныеНомера.Номенклатура ЕСТЬ NULL 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗагруженныеСН.Номенклатура,
		|	ЗагруженныеСН.Контейнер,
		|	ЗагруженныеСН.СерийныйНомер,
		|	ЗагруженныеСН.СерийныйНомерПо,
		|	ЗагруженныеСН.ПартияНоменклатуры
		|ИЗ
		|	ЗагруженныеСН КАК ЗагруженныеСН
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.усСерийныеНомера КАК усСерийныеНомера
		|		ПО ЗагруженныеСН.Номенклатура = усСерийныеНомера.Номенклатура
		|			И ЗагруженныеСН.Контейнер = усСерийныеНомера.Контейнер
		|			И (ЗагруженныеСН.СерийныйНомер ПОДОБНО усСерийныеНомера.СерийныйНомер)
		|			И ЗагруженныеСН.СерийныйНомерПо = усСерийныеНомера.СерийныйНомерПо
		|			И ЗагруженныеСН.ПартияНоменклатуры = усСерийныеНомера.ПартияНоменклатуры
		|ГДЕ
		|	НЕ усСерийныеНомера.Номенклатура ЕСТЬ NULL ";
		Запрос.УстановитьПараметр("ЗагруженныеСН", СНДляНабораЗаписей);
		НаборСерийныеНомера = РегистрыСведений.усСерийныеНомера.СоздатьНаборЗаписей();
		РезультатВыборки = Запрос.ВыполнитьПакет();
		НаборСерийныеНомера.Загрузить(РезультатВыборки[1].Выгрузить());
		НаборСерийныеНомера.Записать(Ложь);
		ДанныеДляЗаписиСН.Очистить();
		ОповеститьОНайденныхСНСервер(РезультатВыборки[2].Выбрать());
	КонецЕсли;

КонецПроцедуры // ЗаписатьСНСервер()

&НаСервере
Процедура ОповеститьОНайденныхСНСервер(РезультатВыборки)

	Пока РезультатВыборки.Следующий() Цикл
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Серийный номер ""%1"" уже был в БД.'"), Строка(РезультатВыборки.СерийныйНомер));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЦикла;

КонецПроцедуры // ОповеститьОНайденныхСНСервер()

&НаСервере
Процедура ЗагрузитьСНВБДНаСервере(ИндексСтроки)

	СтрокаСН = Объект.СерийныеНомера.Получить(ИндексСтроки);
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("Номенклатура", НоменклатураПоИдентификатору(СтрокаСН.Номенклатура, СтрокаСН.Характеристика));
	СтруктураЗаписи.Вставить("Контейнер", КонтейнерПоТипуКонтейнера(СтрокаСН.ТипКонтейнера, СтрокаСН.НомерКонтейнера));
	СтруктураЗаписи.Вставить("СерийныйНомер", СтрокаСН.СерийныйНомер);
	Если СтруктураЗаписи.Номенклатура = Неопределено Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'В строке %1 не найдена номенклатура.'"), Строка(СтрокаСН.НомерСтроки));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	Если СтруктураЗаписи.Контейнер = Неопределено Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'В строке %1 не найден контейнер.'"), Строка(СтрокаСН.НомерСтроки));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	Если ПустаяСтрока(СтрокаСН.СерийныйНомер) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'В строке %1 не указан серийный номер.'"), Строка(СтрокаСН.НомерСтроки));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	НовыйСН = ДанныеДляЗаписиСН.Добавить();
	ЗаполнитьЗначенияСвойств(НовыйСН, СтруктураЗаписи);
	НовыйСН.СерийныйНомерПо = "";
	НовыйСН.ПартияНоменклатуры = Справочники.усПартииНоменклатуры.ПустаяСсылка();
	СтрокаСН.ЗагруженВБД = Истина;

КонецПроцедуры

&Насервере
Функция НоменклатураПоИдентификатору(ИдНоменклатура, ИдХарактеристика)

	Номенклатура = Неопределено;
	Идентификаторы = Новый Массив;
	Идентификаторы.Добавить(ИдНоменклатура);
	Идентификаторы.Добавить(ИдХарактеристика);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	усИдентификаторыОбменаПоискОбъекта.Объект,
	|	усИдентификаторыОбменаПоискОбъекта.Идентификатор
	|ПОМЕСТИТЬ ДанныеКИС
	|ИЗ
	|	РегистрСведений.усИдентификаторыОбмена КАК усИдентификаторыОбменаПоискОбъекта
	|ГДЕ
	|	усИдентификаторыОбменаПоискОбъекта.Идентификатор В(&Идентификаторы)
	|	И ТИПЗНАЧЕНИЯ(усИдентификаторыОбменаПоискОбъекта.Объект) <> ТИП(СТРОКА)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	усНоменклатура.Ссылка КАК Номенклатура
	|ИЗ
	|	ДанныеКИС КАК ДанныеКИС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.усНоменклатура КАК усНоменклатура
	|		ПО ДанныеКИС.Объект = усНоменклатура.НоменклатураКИС
	|ГДЕ
	|	усНоменклатура.ХарактеристикаНоменклатурыКИС = ЗНАЧЕНИЕ(Справочник.усХарактеристикиНоменклатурыКИС.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	усНоменклатура.Ссылка
	|ИЗ
	|	ДанныеКИС КАК ДанныеКИС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.усНоменклатура КАК усНоменклатура
	|		ПО ДанныеКИС.Объект = усНоменклатура.ХарактеристикаНоменклатурыКИС";
	Запрос.УстановитьПараметр("Идентификаторы", Идентификаторы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И ЗначениеЗаполнено(Выборка.Номенклатура) Тогда
		Номенклатура = Выборка.Номенклатура;
	КонецЕсли;

	Возврат Номенклатура;

КонецФункции // НоменклатураПоИдентификатору()

&Насервере
Функция КонтейнерПоТипуКонтейнера(ИдТипаКонтейнера, НомерКонтейнера)

	Контейнер = Неопределено;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	усИдентификаторыОбменаПоискОбъекта.Объект,
	|	усИдентификаторыОбменаПоискОбъекта.Идентификатор
	|ПОМЕСТИТЬ ДанныеКИС
	|ИЗ
	|	РегистрСведений.усИдентификаторыОбмена КАК усИдентификаторыОбменаПоискОбъекта
	|ГДЕ
	|	усИдентификаторыОбменаПоискОбъекта.Идентификатор = &Идентификатор
	|	И ТИПЗНАЧЕНИЯ(усИдентификаторыОбменаПоискОбъекта.Объект) <> ТИП(СТРОКА)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	усКонтейнеры.Ссылка
	|ИЗ
	|	ДанныеКИС КАК ДанныеКИС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.усКонтейнеры КАК усКонтейнеры
	|		ПО ДанныеКИС.Объект = усКонтейнеры.ТипКонтейнера
	|ГДЕ
	|	усКонтейнеры.Наименование = &НомерКонтейнера";
	Запрос.УстановитьПараметр("Идентификатор", ИдТипаКонтейнера);
	Запрос.УстановитьПараметр("НомерКонтейнера", НомерКонтейнера);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И ЗначениеЗаполнено(Выборка.Ссылка) Тогда
		Контейнер = Выборка.Ссылка;
	КонецЕсли;

	Возврат Контейнер;

КонецФункции // КонтейнерПоТипуКонтейнера()

&НаКлиенте
Процедура УстановитьДоступностьЗагрузкиСН(Включить = Истина)

	Элементы.ФормаКоманднаяПанель.ПодчиненныеЭлементы.ФормаЗагрузитьСНВБД.Доступность = Объект.СерийныеНомера.Количество() И Включить;

КонецПроцедуры // УстановитьДоступностьЗагрузкиСН()

&НаКлиенте
Процедура ЗагрузитьДанныеФайлаВТабличныйДокумент()

	Объект.СерийныеНомера.Очистить();
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		WB    = Excel.Workbooks.Open(Объект.ПутьКФайлу);
		WS    = WB.Worksheets(1);
		arr   = WS.UsedRange.Value;
		WB.Close(0);
		МассивКолонок = arr.Выгрузить();
		ВсегоСтрок   = (МассивКолонок.Получить(0).Количество())-1;
	Исключение
		Сообщить(ОписаниеОшибки());
		Попытка
			Excel.Application.Quit();
		Исключение
		КонецПопытки;
		Excel = Неопределено;
		Возврат;
	КонецПопытки;
	
	Для Индекс = 1 По ВсегоСтрок Цикл
		НоваяСтрока = Объект.СерийныеНомера.Добавить();
		НоваяСтрока.Номенклатура = МассивКолонок.Получить(0).Получить(Индекс);
		НоваяСтрока.Характеристика = МассивКолонок.Получить(1).Получить(Индекс);
		НоваяСтрока.ТипКонтейнера = МассивКолонок.Получить(2).Получить(Индекс);
		НоваяСтрока.НомерКонтейнера = СокрЛП(СтрЗаменить(МассивКолонок.Получить(3).Получить(Индекс), Символы.НПП, ""));
		НоваяСтрока.СерийныйНомер = СокрЛП(СтрЗаменить(МассивКолонок.Получить(4).Получить(Индекс), Символы.НПП, ""));
		УстановитьСостояниеЗагрузки(ПроцентВыполнения(Индекс, ВсегоСтрок), Истина);
	КонецЦикла;

КонецПроцедуры // ЗагрузитьДанныеФайлаВТабличныйДокумент()

&НаКлиенте
Процедура УстановитьСостояниеЗагрузки(ПроценОбработки, ЗагрузкаИзЭкселя)

	ТекстСообщения = "";
	Если ЗагрузкаИзЭкселя Тогда
		ТекстСообщения = НСтр("ru = 'Загрузка данных из файла'");
	Иначе
		ТекстСообщения = НСтр("ru = 'Загрузка данных в базу данных'");
	КонецЕсли;
	Состояние(ТекстСообщения, ПроценОбработки);

КонецПроцедуры // УстановитьСостояниеЗагрузки()

&НаКлиенте
Процедура ОповещениеЗагрузкиСерийныхНомеровВБД(Событие, Параметр, Источник)Экспорт

	Если Событие = "ЗагрузкаСНВБД" Тогда
		УстановитьСостояниеЗагрузки(Параметр, Ложь);
	КонецЕсли;

КонецПроцедуры // ОповещениеЗагрузкиСерийныхНомеровВБД()

&НаКлиентеНаСервереБезКонтекста
Функция ПроцентВыполнения(ОбщееКоличество, Обработано)

	Возврат Обработано / ОбщееКоличество * 100;

КонецФункции // ПроцентВыполнения()

#КонецОбласти