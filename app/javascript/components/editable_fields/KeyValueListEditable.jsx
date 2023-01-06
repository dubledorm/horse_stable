import React from "react"
import PropTypes from "prop-types"
import KeyValueEditable from "./KeyValueEditable";


class KeyValueListEditable extends React.Component {
    constructor(props) {
        super(props);
        let variables = [];
        try {
            variables = JSON.parse(props.variables_json);
        } catch(e) {
            variables = [];
        }

        if (!variables) {
            variables = [];
        }
        this.state = {
            variables: variables.concat({key: '', value: ''}),
            backup_variables: variables.concat({key: '', value: ''})
        }
        this.onChangeVariableValue = this.onChangeVariableValue.bind(this);
        this.onChangeVariableKey = this.onChangeVariableKey.bind(this);
    }


    onChangeVariableValue(row_number, new_value) {
        // Вызывается при изменении строки таблицы. А именно, при потере фокуса
        let new_variables = [];
        let index = 0;
        for (let variable of this.state.variables) {
            if (index == row_number) {
                new_variables.push({key: variable.key, value: new_value});
            } else
                new_variables.push(variable);
            index += 1;
        }

        this.setState({variables: new_variables});
        this.escalateState(new_variables)
    }

    onChangeVariableKey(row_number, new_key) {
        // Вызывается при изменении строки таблицы. А именно, при потере фокуса
        let new_variables = [];
        let index = 0;
        for (let variable of this.state.variables) {
            if (index == row_number) {
                new_variables.push({key: new_key, value: variable.value});
            } else
                new_variables.push(variable);
            index += 1;
        }

        // Проверяем, что нет последней строчки
        if (new_variables[index - 1].key)
            new_variables.push({key: '', value: ''});

        this.setState({variables: new_variables});
        this.escalateState(new_variables)
    }

    escalateState(new_variables) {
        let variables = []
        for (let variable of new_variables) {
            if (variable.value && variable.key) {
                variables.push(variable);
            }
        };
        this.props.on_change_value(JSON.stringify(variables));
    }

    render() {
        let content = [];
        let index = 100;

        for (let variable of this.state.variables) {
            content.push(
                <KeyValueEditable key={index} row_number={index-100}
                                     key_name={variable.key || ''}
                                     value={variable.value || ''}
                                     edit_mode={this.props.edit_mode}
                                     onChangeValue={this.onChangeVariableValue}
                                     onChangeKey={this.onChangeVariableKey}/>
            )
            index += 1;
        }

        return (
            <React.Fragment>
                <table>
                    <thead>
                    <tr>
                        <th>{this.props.title_first_column}</th>
                        <th>{this.props.title_second_column}</th>
                    </tr>
                    </thead>
                    <tbody>
                    {content}
                    </tbody>
                </table>
            </React.Fragment>);
    }
}

KeyValueListEditable.propTypes = {
    variables_json: PropTypes.string,
    edit_mode: PropTypes.bool,
    on_change_value: PropTypes.func,
    title_first_column: PropTypes.string,
    title_second_column: PropTypes.string
};


export default KeyValueListEditable