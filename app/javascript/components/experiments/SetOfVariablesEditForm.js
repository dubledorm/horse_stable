import React from "react"
import PropTypes from "prop-types"
import BtnCancel from "../editable_fields/BtnCancel";
import BtnPrimary from "../editable_fields/BtnPrimary";
import VariableEditField from "./VariableEditField";

class SetOfVariablesEditForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            human_set_name: props.human_set_name,
            variables: this.createArrayOfRows(),
            prev_variables: [],
            edit_mode: this.props.edit_mode,
            error_message: ''
        }
        this.onSubmit = this.onSubmit.bind(this);
        this.onSubmitSuccess = this.onSubmitSuccess.bind(this);
        this.onSubmitError = this.onSubmitError.bind(this);
        this.onCancel = this.onCancel.bind(this);
        this.onEdit = this.onEdit.bind(this);
        this.onDeleteVariable = this.onDeleteVariable.bind(this);
        this.onAddVariable = this.onAddVariable.bind(this);
        this.onChangeVariable = this.onChangeVariable.bind(this);
        this.onChangeHumanName = this.onChangeHumanName.bind(this);
    }

    createArrayOfRows() {
        let arrayOfRows = [];
        let i = 1;
        for (let key_name in this.props.variables) {
            arrayOfRows.push({
                key: i++,
                variable_name: key_name,
                variable_value: this.props.variables[key_name]
            })
        }

        if (arrayOfRows.length === 0) {
            arrayOfRows.push({
                key: 1,
                variable_name: '',
                variable_value: ''
            })
        }
        return arrayOfRows;
    }

    maxRowKew() {
        let result = 0;
        for (let variable of this.state.variables) {
            if (variable['key'] > result) {
                result = variable['key'];
            }
        }
        return result + 1;
    }

    onSubmit() {
        $.ajax({
            type: "POST",
            url: this.props.url,
            dataType: "json",
            data: {
                ['set_of_variables']: {
                    ['set_id']: this.props.set_id,
                    ['human_set_name']: this.state.human_set_name,
                    ['variables']: this.state.variables
                }
            },
            success: this.onSubmitSuccess,
            error: this.onSubmitError
        });
    }

    onSubmitSuccess() {
        this.setState({error_message: ''});
    }

    onSubmitError(error) {
        let error_message = error.responseText || error.statusText;
        console.error(`Submit error. Status = ${error.status}. Message = ${error_message}`);
        this.setState({error_message: error_message});
    }

    onEdit() {
        this.setState({edit_mode: false});
    }

    onCancel() {
        this.setState({edit_mode: false});
    }

    onChangeHumanName(event) {
        this.setState({human_set_name: event.target.value});
    }

    onChangeVariable(event) {
        const target = event.target;
        const name = target.name;
        const field_type = name.indexOf('variable_name_') === 0 ? 'variable_name' : 'variable_value';
        const row_key = name.slice(field_type.length + 1);

        let new_variables = this.state.variables.slice(0); // Копируем массив
        let row_for_change = new_variables.find(function (item, index, array) {
            return item.key == row_key;

        });
        row_for_change[field_type] = event.target.value;
        this.setState({variables: new_variables});
    }

    onDeleteVariable(row_key) {
        let new_variables = this.state.variables.slice(0); // Копируем массив
        let row_for_delete = new_variables.findIndex(function (item, index, array) {
            return item.key == row_key;

        });
        new_variables.splice(row_for_delete, 1);
        this.setState({variables: new_variables});
    }

    onAddVariable() {
        let new_variables = this.state.variables.slice(0);
        new_variables.push({key: this.maxRowKew(), variable_name: '', variable_value: ''});
        this.setState({variables: new_variables});
    }

    createRowsOfVariables() {
        let result;
        result = this.state.variables.map((variable_row) => <div className="form-group" key={variable_row['key']}>
                <VariableEditField row_key={String(variable_row['key'])}
                                   variable_name={variable_row['variable_name']}
                                   variable_value={variable_row['variable_value']}
                                   on_delete={this.onDeleteVariable}
                                   onChangeVariable={this.onChangeVariable}/>
            </div>
        )
        return result;
    }

    render() {
        let context;
        let error_message = '';
        if (this.state.error_message) {
            error_message = <div className="rc-field-error">{this.state.error_message}</div>
        }
        if (this.state.edit_mode) {
            context = <div className='rc-form-buttons'>
                <div className="form-group required">
                    <div className="rc-editable-field-title">
                        <h2>Название группы</h2>
                        <input type="text" name="human_set_name" className="form-control" defaultValue={this.state.human_set_name}
                               onChange={this.onChangeHumanName}/>
                    </div>
                </div>
                <div className="inline-form-group">
                    <div className={'label-field-name'}>Название</div>
                    <div className={'label-field-value'}>Значение</div>
                </div>
                {this.createRowsOfVariables()}
                <div className="form-group add-button">
                    <BtnPrimary onClickHandler={this.onAddVariable}>+</BtnPrimary>
                </div>
                {error_message}
                <BtnCancel onClickHandler={this.onCancel}>{this.props.cancel_button_text}</BtnCancel>
                <BtnPrimary onClickHandler={this.onSubmit}>{this.props.submit_button_text}</BtnPrimary>
            </div>;
        } else {
            context = <div className='rc-form-buttons'>
                <BtnPrimary onClickHandler={this.onEdit}>{this.props.edit_button_text}</BtnPrimary>
            </div>;
        }

        return (
            <div className="rc-block-hidden-form">
                <form onSubmit={this.onSubmit}>
                    {context}
                </form>
            </div>);
    }
}

SetOfVariablesEditForm.propTypes = {
    human_set_name: PropTypes.string,
    set_id: PropTypes.string,
    variables: PropTypes.object,
    url: PropTypes.string,
    cancel_button_text: PropTypes.string,
    submit_button_text: PropTypes.string,
    edit_button_text: PropTypes.string,
    edit_mode: PropTypes.bool
};

export default SetOfVariablesEditForm