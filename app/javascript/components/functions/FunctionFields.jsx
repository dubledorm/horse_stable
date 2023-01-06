import React from "react"
import PropTypes from "prop-types"
import FunctionField from "./FunctionField";

class FunctionFields extends React.Component {
    constructor(props) {
        super(props);
    }

    makeFunctionField(field) {
       return <FunctionField key={field}
                             fieldName={field}
                             fieldTitle={this.props.attributes[field]}
                             fieldValues={this.props.attributeValues ? this.props.attributeValues[field] : []}
                             fieldHint={this.props.attributeHints ? this.props.attributeHints[field] : ''}
                             value={this.props.currentAttributeValues ? this.props.currentAttributeValues[field] : ''}
                             edit_mode={this.props.edit_mode}
                             function_name={this.props.function_name}
                             onChangeAttribute={this.props.onChangeAttribute}/>
    }

    render() {
        let result = []; // Массив react элементов в порядке вывода на экран
        let fields_arr = {}; // Храним все названия полей в виде ключей и в значении false если ещё не выводили
        for(let code in this.props.attributes) { fields_arr[code] = false; } // Инициализация. Заполняем именами всех полей

        // Выстраиваем по порядку, указанному в this.props.attributeOrders
        if (this.props.attributeOrders) {
            // Проходим по всем элементам. Элемент может быть строкой или массивом, если несколько полей должны выводиться
            // на одной строке
            for (let field_or_fields of this.props.attributeOrders) {
                if (typeof field_or_fields === "object") { // если это массив
                    let one_row_arr = []; // Сюда собираем react элементы, которые должны выводиться в одной строке
                    let key = 'arr_';
                    for (let field of field_or_fields) {
                        one_row_arr.push(this.makeFunctionField(field));
                        fields_arr[field] = true;
                        key = key + field;
                    }
                    result.push(<div key={key} className={'rc-fields-row'}>{one_row_arr}</div>)
                } else {
                    result.push(this.makeFunctionField(field_or_fields));
                    fields_arr[field_or_fields] = true;
                }
            }
        }

        // Добавляем элементы, которые не были указаны в this.props.attributeOrders
        for(let key in fields_arr) {
            if (!(fields_arr[key])) {
                result.push(this.makeFunctionField(key));
            }
        }

        return result;
    }
}

FunctionFields.propTypes = {
    attributes: PropTypes.object,
    attributeValues: PropTypes.object,
    attributeOrders: PropTypes.array,
    attributeHints: PropTypes.object,
    currentAttributeValues: PropTypes.object,
    onChangeAttribute: PropTypes.func,
    edit_mode: PropTypes.bool,
    function_name: PropTypes.string
};

export default FunctionFields