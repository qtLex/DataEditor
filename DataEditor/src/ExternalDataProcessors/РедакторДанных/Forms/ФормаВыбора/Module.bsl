///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Рарус
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by-sa/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка) 
	ЗаполнитьДеревоМетаданных();	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ) 
	
	Представление = Истина;
	УстановкаВидимостиРеквизитов(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеПриИзменении(Элемент)
	Если Представление Тогда
		УстановкаВидимостиРеквизитов(Истина);
	Иначе
		УстановкаВидимостиРеквизитов(Ложь);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоМетаданныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если Не ТекущиеДанные.Имя = ТекущиеДанные.ОбъектМетаданных Тогда
		Родитель = Элемент.ТекущиеДанные.ПолучитьРодителя().Имя; 
		ОписаниеОповещения = Новый ОписаниеОповещения("Подключаемый_ПослеВыбораЗначения", ЭтотОбъект);
		Если Родитель <> Неопределено Тогда
			Если ТекущиеДанные.ТипОбъекта = "Константа" Тогда
				ПараметрыОбъекта = Новый Структура("Метаданные, ОбъектМетаданных", Родитель, ТекущиеДанные.Имя);
				Закрыть(ПараметрыОбъекта);
			ИначеЕсли ТекущиеДанные.ТипОбъекта = "РегистрСведений" Тогда  
				ПутьДляОткрытияФормы = ТекущиеДанные.ОбъектМетаданных + ".ФормаСписка";
				ОткрытьФорму(ПутьДляОткрытияФормы);
			Иначе 
				ПутьДляОткрытияФормы = ТекущиеДанные.ОбъектМетаданных + ".ФормаВыбора";
				ОткрытьФорму(ПутьДляОткрытияФормы, , , , , , ОписаниеОповещения);
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановкаВидимостиРеквизитов(Представление)
	Если Представление Тогда 
		Элементы.ДеревоМетаданныхГруппаИмя.Видимость = Истина;
		Элементы.ДеревоМетаданныхГруппаСиноним.Видимость = Ложь;
	Иначе 
		Элементы.ДеревоМетаданныхГруппаИмя.Видимость = Ложь;
		Элементы.ДеревоМетаданныхГруппаСиноним.Видимость = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоМетаданных() 
	МассивОбъектов = Новый Массив;
	МассивОбъектов = СозданиеМассиваДанных(МассивОбъектов);

	Для Каждого Элемент Из МассивОбъектов Цикл
		КоличествоЭлементов = Элемент.ОбъектМетаданных.Количество();
		Если КоличествоЭлементов > 0 Тогда 
			СтрокаВерхнегоУровня = ДеревоМетаданных.ПолучитьЭлементы().Добавить();
			ЭлементМетаданные = Элемент.Метаданные;
			СтрокаПодстановки = ОпределитьСтрокуПодстановки(ЭлементМетаданные);
			СтрокаВерхнегоУровня.Имя = ЭлементМетаданные;
			СтрокаВерхнегоУровня.Синоним = ЭлементМетаданные;
			СтрокаВерхнегоУровня.Картинка = БиблиотекаКартинок[СтрокаПодстановки]; 
			СтрокаВерхнегоУровня.ОбъектМетаданных = ЭлементМетаданные;
			Для Каждого ТекОбъект Из Элемент.ОбъектМетаданных Цикл
				Если Элемент.Метаданные = "Регистры сведений" Тогда
					РежимЗаписи = Строка(Метаданные.РегистрыСведений[ТекОбъект.Имя].РежимЗаписи);
					Если РежимЗаписи = "Независимый" Тогда
						СтрокаВторогоУровня = СтрокаВерхнегоУровня.ПолучитьЭлементы().Добавить();
						СтрокаВторогоУровня.ОбъектМетаданных = ТекОбъект.ПолноеИмя(); 	
						СтрокаВторогоУровня.Имя = ТекОбъект.Имя;
						СтрокаВторогоУровня.Картинка = БиблиотекаКартинок[СтрокаПодстановки];
						СтрокаВторогоУровня.ТипОбъекта = СтрокаПодстановки;
						Если ПустаяСтрока(ТекОбъект.Синоним) Тогда
							СтрокаВторогоУровня.Синоним = "(" + ТекОбъект.Имя + ")";
						Иначе
							СтрокаВторогоУровня.Синоним = ТекОбъект.Синоним;
						КонецЕсли;		
					КонецЕсли;
				Иначе
					СтрокаВторогоУровня = СтрокаВерхнегоУровня.ПолучитьЭлементы().Добавить();
					СтрокаВторогоУровня.ОбъектМетаданных = ТекОбъект.ПолноеИмя(); 	
					СтрокаВторогоУровня.Имя = ТекОбъект.Имя;
					СтрокаВторогоУровня.Картинка = БиблиотекаКартинок[СтрокаПодстановки];
					СтрокаВторогоУровня.ТипОбъекта = СтрокаПодстановки;
					Если ПустаяСтрока(ТекОбъект.Синоним) Тогда
						СтрокаВторогоУровня.Синоним = "(" + ТекОбъект.Имя + ")";
					Иначе
						СтрокаВторогоУровня.Синоним = ТекОбъект.Синоним;
					КонецЕсли;		
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция СозданиеМассиваДанных(МассивОбъектов)
	МассивОбъектов.Добавить(Новый Структура("Метаданные, ОбъектМетаданных",
	"Планы обмена", Метаданные.ПланыОбмена)); 
	МассивОбъектов.Добавить(Новый Структура("Метаданные, ОбъектМетаданных",
	"Константы", Метаданные.Константы));
	МассивОбъектов.Добавить(Новый Структура("Метаданные, ОбъектМетаданных",
	"Справочники", Метаданные.Справочники));
	МассивОбъектов.Добавить(Новый Структура("Метаданные, ОбъектМетаданных",
	"Документы", Метаданные.Документы));
	МассивОбъектов.Добавить(Новый Структура("Метаданные, ОбъектМетаданных",
	"Планы видов характеристик", Метаданные.ПланыВидовХарактеристик));
	МассивОбъектов.Добавить(Новый Структура("Метаданные, ОбъектМетаданных",
	"Планы счетов", Метаданные.ПланыСчетов));
	МассивОбъектов.Добавить(Новый Структура("Метаданные, ОбъектМетаданных",
	"Планы видов расчета", Метаданные.ПланыВидовРасчета));
	МассивОбъектов.Добавить(Новый Структура("Метаданные, ОбъектМетаданных",
	"Регистры сведений", Метаданные.РегистрыСведений));
	МассивОбъектов.Добавить(Новый Структура("Метаданные, ОбъектМетаданных",
	"Бизнес-процессы", Метаданные.БизнесПроцессы));
	МассивОбъектов.Добавить(Новый Структура("Метаданные, ОбъектМетаданных",
	"Задачи", Метаданные.Задачи));
	Возврат МассивОбъектов;
КонецФункции

&НаСервере
Функция ОпределитьСтрокуПодстановки(ТипМетаданного)
	Если ТипМетаданного = "Константы" Тогда
		Возврат "Константа";
	ИначеЕсли ТипМетаданного = "Справочники" Тогда
		Возврат "Справочник";
	ИначеЕсли ТипМетаданного = "Документы" Тогда
		Возврат "Документ";
	ИначеЕсли ТипМетаданного = "Планы обмена" Тогда
		Возврат "ПланОбмена";
	ИначеЕсли ТипМетаданного = "Планы видов характеристик" Тогда
		Возврат "ПланВидовХарактеристик";
	ИначеЕсли ТипМетаданного = "Планы счетов" Тогда
		Возврат "ПланСчетов";
	ИначеЕсли ТипМетаданного = "Планы видов расчета" Тогда
		Возврат "ПланВидовРасчета";
	ИначеЕсли ТипМетаданного = "Регистры сведений" Тогда
		Возврат "РегистрСведений";
	ИначеЕсли ТипМетаданного = "Бизнес-процессы" Тогда
		Возврат "БизнесПроцесс";
	ИначеЕсли ТипМетаданного = "Задачи" Тогда
		Возврат "Задача";
	Иначе 
		Возврат Неопределено;
	КонецЕсли;  
КонецФункции  

&НаКлиенте
Процедура Подключаемый_ПослеВыбораЗначения(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Закрыть(ВыбранноеЗначение);
КонецПроцедуры

#КонецОбласти
