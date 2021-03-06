import AppKit
import Foundation

// MARK: - ColorRow

public class ColorRow: NSBox {

  // MARK: Lifecycle

  public init(_ parameters: Parameters) {
    self.parameters = parameters

    super.init(frame: .zero)

    setUpViews()
    setUpConstraints()

    update()
  }

  public convenience init(
    titleText: String,
    subtitleText: String,
    selected: Bool,
    disabled: Bool,
    previewColor: NSColor)
  {
    self
      .init(
        Parameters(
          titleText: titleText,
          subtitleText: subtitleText,
          selected: selected,
          disabled: disabled,
          previewColor: previewColor))
  }

  public convenience init() {
    self.init(Parameters())
  }

  public required init?(coder aDecoder: NSCoder) {
    self.parameters = Parameters()

    super.init(coder: aDecoder)

    setUpViews()
    setUpConstraints()

    update()
  }

  // MARK: Public

  public var titleText: String {
    get { return parameters.titleText }
    set {
      if parameters.titleText != newValue {
        parameters.titleText = newValue
      }
    }
  }

  public var subtitleText: String {
    get { return parameters.subtitleText }
    set {
      if parameters.subtitleText != newValue {
        parameters.subtitleText = newValue
      }
    }
  }

  public var selected: Bool {
    get { return parameters.selected }
    set {
      if parameters.selected != newValue {
        parameters.selected = newValue
      }
    }
  }

  public var disabled: Bool {
    get { return parameters.disabled }
    set {
      if parameters.disabled != newValue {
        parameters.disabled = newValue
      }
    }
  }

  public var previewColor: NSColor {
    get { return parameters.previewColor }
    set {
      if parameters.previewColor != newValue {
        parameters.previewColor = newValue
      }
    }
  }

  public var parameters: Parameters {
    didSet {
      if parameters != oldValue {
        update()
      }
    }
  }

  // MARK: Private

  private var colorPreviewView = NSBox()
  private var detailsView = NSBox()
  private var textView = LNATextField(labelWithString: "")
  private var subtitleView = LNATextField(labelWithString: "")

  private var textViewTextStyle = TextStyles.row
  private var subtitleViewTextStyle = TextStyles.sectionHeader

  private func setUpViews() {
    boxType = .custom
    borderType = .noBorder
    contentViewMargins = .zero
    colorPreviewView.boxType = .custom
    colorPreviewView.borderType = .noBorder
    colorPreviewView.contentViewMargins = .zero
    detailsView.boxType = .custom
    detailsView.borderType = .noBorder
    detailsView.contentViewMargins = .zero
    textView.lineBreakMode = .byWordWrapping
    subtitleView.lineBreakMode = .byWordWrapping

    addSubview(colorPreviewView)
    addSubview(detailsView)
    detailsView.addSubview(textView)
    detailsView.addSubview(subtitleView)

    colorPreviewView.cornerRadius = 4
    textView.maximumNumberOfLines = 1
    subtitleView.maximumNumberOfLines = 1
  }

  private func setUpConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
    colorPreviewView.translatesAutoresizingMaskIntoConstraints = false
    detailsView.translatesAutoresizingMaskIntoConstraints = false
    textView.translatesAutoresizingMaskIntoConstraints = false
    subtitleView.translatesAutoresizingMaskIntoConstraints = false

    let colorPreviewViewHeightAnchorParentConstraint = colorPreviewView
      .heightAnchor
      .constraint(lessThanOrEqualTo: heightAnchor, constant: -8)
    let detailsViewHeightAnchorParentConstraint = detailsView
      .heightAnchor
      .constraint(lessThanOrEqualTo: heightAnchor, constant: -8)
    let colorPreviewViewLeadingAnchorConstraint = colorPreviewView
      .leadingAnchor
      .constraint(equalTo: leadingAnchor, constant: 12)
    let colorPreviewViewTopAnchorConstraint = colorPreviewView.topAnchor.constraint(equalTo: topAnchor, constant: 4)
    let detailsViewTrailingAnchorConstraint = detailsView
      .trailingAnchor
      .constraint(equalTo: trailingAnchor, constant: -12)
    let detailsViewLeadingAnchorConstraint = detailsView
      .leadingAnchor
      .constraint(equalTo: colorPreviewView.trailingAnchor, constant: 8)
    let detailsViewTopAnchorConstraint = detailsView.topAnchor.constraint(equalTo: topAnchor, constant: 4)
    let detailsViewBottomAnchorConstraint = detailsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
    let colorPreviewViewHeightAnchorConstraint = colorPreviewView.heightAnchor.constraint(equalToConstant: 32)
    let colorPreviewViewWidthAnchorConstraint = colorPreviewView.widthAnchor.constraint(equalToConstant: 32)
    let textViewTopAnchorConstraint = textView.topAnchor.constraint(equalTo: detailsView.topAnchor)
    let textViewLeadingAnchorConstraint = textView.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor)
    let textViewTrailingAnchorConstraint = textView
      .trailingAnchor
      .constraint(lessThanOrEqualTo: detailsView.trailingAnchor)
    let subtitleViewBottomAnchorConstraint = subtitleView.bottomAnchor.constraint(equalTo: detailsView.bottomAnchor)
    let subtitleViewTopAnchorConstraint = subtitleView.topAnchor.constraint(equalTo: textView.bottomAnchor)
    let subtitleViewLeadingAnchorConstraint = subtitleView.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor)
    let subtitleViewTrailingAnchorConstraint = subtitleView
      .trailingAnchor
      .constraint(lessThanOrEqualTo: detailsView.trailingAnchor)

    colorPreviewViewHeightAnchorParentConstraint.priority = NSLayoutConstraint.Priority.defaultLow
    detailsViewHeightAnchorParentConstraint.priority = NSLayoutConstraint.Priority.defaultLow

    NSLayoutConstraint.activate([
      colorPreviewViewHeightAnchorParentConstraint,
      detailsViewHeightAnchorParentConstraint,
      colorPreviewViewLeadingAnchorConstraint,
      colorPreviewViewTopAnchorConstraint,
      detailsViewTrailingAnchorConstraint,
      detailsViewLeadingAnchorConstraint,
      detailsViewTopAnchorConstraint,
      detailsViewBottomAnchorConstraint,
      colorPreviewViewHeightAnchorConstraint,
      colorPreviewViewWidthAnchorConstraint,
      textViewTopAnchorConstraint,
      textViewLeadingAnchorConstraint,
      textViewTrailingAnchorConstraint,
      subtitleViewBottomAnchorConstraint,
      subtitleViewTopAnchorConstraint,
      subtitleViewLeadingAnchorConstraint,
      subtitleViewTrailingAnchorConstraint
    ])
  }

  private func update() {
    subtitleViewTextStyle = TextStyles.sectionHeader
    subtitleView.attributedStringValue = subtitleViewTextStyle.apply(to: subtitleView.attributedStringValue)
    textViewTextStyle = TextStyles.row
    textView.attributedStringValue = textViewTextStyle.apply(to: textView.attributedStringValue)
    textView.attributedStringValue = textViewTextStyle.apply(to: titleText)
    subtitleView.attributedStringValue = subtitleViewTextStyle.apply(to: subtitleText)
    colorPreviewView.fillColor = previewColor
    if selected {
      textViewTextStyle = TextStyles.rowInverse
      textView.attributedStringValue = textViewTextStyle.apply(to: textView.attributedStringValue)
      subtitleViewTextStyle = TextStyles.sectionHeaderInverse
      subtitleView.attributedStringValue = subtitleViewTextStyle.apply(to: subtitleView.attributedStringValue)
    }
    if disabled {
      textViewTextStyle = TextStyles.rowDisabled
      textView.attributedStringValue = textViewTextStyle.apply(to: textView.attributedStringValue)
    }
  }
}

// MARK: - Parameters

extension ColorRow {
  public struct Parameters: Equatable {
    public var titleText: String
    public var subtitleText: String
    public var selected: Bool
    public var disabled: Bool
    public var previewColor: NSColor

    public init(titleText: String, subtitleText: String, selected: Bool, disabled: Bool, previewColor: NSColor) {
      self.titleText = titleText
      self.subtitleText = subtitleText
      self.selected = selected
      self.disabled = disabled
      self.previewColor = previewColor
    }

    public init() {
      self.init(titleText: "", subtitleText: "", selected: false, disabled: false, previewColor: NSColor.clear)
    }

    public static func ==(lhs: Parameters, rhs: Parameters) -> Bool {
      return lhs.titleText == rhs.titleText &&
        lhs.subtitleText == rhs.subtitleText &&
          lhs.selected == rhs.selected && lhs.disabled == rhs.disabled && lhs.previewColor == rhs.previewColor
    }
  }
}

// MARK: - Model

extension ColorRow {
  public struct Model: LonaViewModel, Equatable {
    public var id: String?
    public var parameters: Parameters
    public var type: String {
      return "ColorRow"
    }

    public init(id: String? = nil, parameters: Parameters) {
      self.id = id
      self.parameters = parameters
    }

    public init(_ parameters: Parameters) {
      self.parameters = parameters
    }

    public init(titleText: String, subtitleText: String, selected: Bool, disabled: Bool, previewColor: NSColor) {
      self
        .init(
          Parameters(
            titleText: titleText,
            subtitleText: subtitleText,
            selected: selected,
            disabled: disabled,
            previewColor: previewColor))
    }

    public init() {
      self.init(titleText: "", subtitleText: "", selected: false, disabled: false, previewColor: NSColor.clear)
    }
  }
}
