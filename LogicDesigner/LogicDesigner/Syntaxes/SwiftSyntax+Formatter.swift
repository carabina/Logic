//
//  SwiftSyntax+TextElements.swift
//  LogicDesigner
//
//  Created by Devin Abbott on 2/19/19.
//  Copyright © 2019 BitDisco, Inc. All rights reserved.
//

import AppKit
import Logic

extension SwiftIdentifier {
    var formatted: LogicEditorFormatCommand {
        return .element(LogicEditorElement.dropdown(id, string, Colors.editableText))
    }
}

extension SwiftPattern {
    var formatted: LogicEditorFormatCommand {
        return .element(LogicEditorElement.dropdown(id, name, Colors.editableText))
    }
}

extension SwiftBinaryOperator {
    var formatted: LogicEditorFormatCommand {
        return .element(LogicEditorElement.dropdown(uuid, displayText, Colors.text))
    }
}

extension SwiftFunctionCallArgument {
    var formatted: LogicEditorFormatCommand {
        return .concat {
            [
                .element(.text(self.label + " :")),
                self.expression.formatted
            ]
        }
    }
}

extension SwiftExpression {
    var formatted: LogicEditorFormatCommand {
        switch self {
        case .identifierExpression(let value):
            return value.identifier.formatted
        case .binaryExpression(let value):
            switch value.op {
            case .setEqualTo:
                return .concat {
                    [
                        value.left.formatted,
                        .element(.text("=")),
                        value.right.formatted
                    ]
                }
            default:
                return .concat {
                    [
                        value.left.formatted,
                        value.op.formatted,
                        value.right.formatted
                    ]
                }
            }
        case .functionCallExpression(let value):
            return .concat {
                [
                    value.expression.formatted,
                    .element(.text("(")),
                    .indent {
                        .concat {
                            [
                                .line,
                                .join(with: .concat {[.element(.text(",")), .line]}) {
                                    value.arguments.map { $0.formatted }
                                }
                            ]
                        }
                    },
                    .element(.text(")"))
                ]
            }
        }
    }
}

extension SwiftStatement {
    var formatted: LogicEditorFormatCommand {
        switch self {
        case .loop(let loop):
            return .concat {
                [
                    .element(LogicEditorElement.dropdown(loop.id, "For", NSColor.black)),
                    loop.pattern.formatted,
                    .element(LogicEditorElement.text("in")),
                    loop.expression.formatted,
                ]
            }
        case .branch(let branch):
            return .concat {
                [
                    .element(LogicEditorElement.dropdown(branch.id, "If", NSColor.black)),
                    branch.condition.formatted,
                    .indent {
                        .concat {
                            [
                                .hardLine,
                                .join(with: .hardLine) {
                                    branch.block.map { $0.formatted }
                                }
                            ]
                        }
                    }
                ]
            }
        case .placeholderStatement(let value):
            return .element(LogicEditorElement.dropdown(value.id, "", Colors.editableText))
        case .expressionStatement(let value):
            return value.expression.formatted
        default:
            return .hardLine
        }
    }
}


extension SwiftProgram {
    var formatted: LogicEditorFormatCommand {
        return .join(with: .hardLine) {
            self.block.map { $0.formatted }
        }
    }
}


extension SwiftSyntaxNode {
    var formatted: LogicEditorFormatCommand {
        switch self {
        case .statement(let value):
            return value.formatted
        case .declaration:
            fatalError("Handle declarations")
        case .identifier(let value):
            return value.formatted
        case .pattern(let value):
            return value.formatted
        case .binaryOperator(let value):
            return value.formatted
        case .expression(let value):
            return value.formatted
        case .program(let value):
            return value.formatted
        }
    }

    func elementRange(for targetID: SwiftUUID) -> Range<Int>? {
        let topNode = topNodeWithEqualElements(as: targetID)
        let topNodeFormattedElements = topNode.formatted.elements

        guard let topFirstFocusableIndex = topNodeFormattedElements.firstIndex(where: { $0.syntaxNodeID != nil }) else { return nil }

        guard let firstIndex = formatted.elements.firstIndex(where: { formattedElement in
            guard let id = formattedElement.syntaxNodeID else { return false }
            return id == topNodeFormattedElements[topFirstFocusableIndex].syntaxNodeID
        }) else { return nil }

        let lastIndex = firstIndex + (topNodeFormattedElements.count - topFirstFocusableIndex - 1)

        return firstIndex..<lastIndex
    }

    func topNodeWithEqualElements(as targetID: SwiftUUID) -> SwiftSyntaxNode {
        let elementPath = uniqueElementPathTo(id: targetID)

        return elementPath[elementPath.count - 1]
    }

    func uniqueElementPathTo(id targetID: SwiftUUID) -> [SwiftSyntaxNode] {
        guard let pathToTarget = pathTo(id: targetID), pathToTarget.count > 0 else {
            fatalError("Node not found")
        }

        let (_, uniquePath): (min: Int, path: [SwiftSyntaxNode]) = pathToTarget
            .reduce((min: Int.max, path: []), { result, next in
                let formattedElements = next.formatted.elements
                if formattedElements.count < result.min {
                    return (formattedElements.count, result.path + [next])
                } else {
                    return result
                }
            })

        return uniquePath
    }
}
