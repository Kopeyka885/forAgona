// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Text {

  internal enum Authorization {
    /// Еще не зарегистрированы? 
    internal static let didNotRegistered = Text.tr("Localizable", "Authorization.didNotRegistered")
    /// Адрес электронной почты
    internal static let emailAddres = Text.tr("Localizable", "Authorization.emailAddres")
    /// Войти
    internal static let enter = Text.tr("Localizable", "Authorization.enter")
    /// Неверный логин или пароль
    internal static let invalidCredentials = Text.tr("Localizable", "Authorization.invalidCredentials")
    /// Пароль
    internal static let password = Text.tr("Localizable", "Authorization.password")
    ///  Регистрация
    internal static let registration = Text.tr("Localizable", "Authorization.registration")
  }

  internal enum Common {
    /// Все
    internal static let all = Text.tr("Localizable", "Common.all")
    /// Отмена
    internal static let cancel = Text.tr("Localizable", "Common.cancel")
    /// Закрыть
    internal static let close = Text.tr("Localizable", "Common.close")
    /// Сохранить
    internal static let dave = Text.tr("Localizable", "Common.dave")
    /// Готово
    internal static let done = Text.tr("Localizable", "Common.done")
    /// Выйти
    internal static let logout = Text.tr("Localizable", "Common.logout")
    /// Далее
    internal static let next = Text.tr("Localizable", "Common.next")
    /// Нет
    internal static let no = Text.tr("Localizable", "Common.no")
    /// Профиль
    internal static let profile = Text.tr("Localizable", "Common.profile")
    /// Удалить
    internal static let remove = Text.tr("Localizable", "Common.remove")
    /// Обновить
    internal static let update = Text.tr("Localizable", "Common.update")
    /// Да
    internal static let yes = Text.tr("Localizable", "Common.yes")
  }

  internal enum Films {
    /// Добавить
    internal static let add = Text.tr("Localizable", "Films.add")
    /// Коллекция
    internal static let collection = Text.tr("Localizable", "Films.collection")
    /// Просмотрено
    internal static let watched = Text.tr("Localizable", "Films.watched")
    /// Буду смотреть
    internal static let willWatch = Text.tr("Localizable", "Films.willWatch")
  }

  internal enum Registration {
    /// Подтвердите пароль
    internal static let confirmPassword = Text.tr("Localizable", "Registration.confirmPassword")
    /// Пароли не совпадают
    internal static let passwordsDontMatch = Text.tr("Localizable", "Registration.passwordsDontMatch")
  }

  internal enum Search {
    /// Начните вводить название, и здесь появятся варианты фильмов
    internal static let hint = Text.tr("Localizable", "Search.hint")
    /// IMDB
    internal static let imdb = Text.tr("Localizable", "Search.imdb")
    /// Рекомендации
    internal static let recomendation = Text.tr("Localizable", "Search.recomendation")
    /// Поиск
    internal static let search = Text.tr("Localizable", "Search.search")
    /// Введите название
    internal static let textfieldPlaceholder = Text.tr("Localizable", "Search.textfieldPlaceholder")
    /// Top 250
    internal static let topFilms = Text.tr("Localizable", "Search.topFilms")
  }

  internal enum Test {
    /// Test 123
    internal static let test = Text.tr("Localizable", "Test.test")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Text {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
