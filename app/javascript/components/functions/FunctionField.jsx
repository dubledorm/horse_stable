import React from "react"
import PropTypes from "prop-types"
import JSONEditorReact from "jsoneditor/examples/react_advanced_demo/src/JSONEditorReact";
import KeyValueListEditable from "../editable_fields/KeyValueListEditable";
import JsonEditorComponent from "../json_editor/json_editor_component";


function CreateForEditMode(props) {
    let value = props.value;

    if (value === undefined || value == null) {
        value = '';
    }

    if (props.function_name === 'http_request') {
        if (props.field_name === 'request_header_json') {
            return <KeyValueListEditable variables_json={props.value} edit_mode={true} title_first_column={'Название'}
                                         title_second_column={'Значение'} on_change_value={props.OnChangeKeyValue}/>
        }
        if (props.field_name === 'result_selector_json') {
            return <KeyValueListEditable variables_json={props.value} edit_mode={true} title_first_column={'Переменная'}
                                         title_second_column={'XPath'} on_change_value={props.OnChangeKeyValue}/>
        }
        if (props.field_name === 'request_body') {
            if (value === '')
                value = '{}';
            return <JsonEditorComponent json={JSON.parse(value)} onChange={props.OnChangeKeyValue}/>
            // return <textarea type="text"
            //               name={props.fieldName}
            //               className="form-control"
            //               value={value}
            //               rows={5}
            //               onChange={props.onChangeAttribute}
            //               disabled={!props.edit_mode}/>;
        }
    }


    if (props.fieldValues !== undefined && props.fieldValues !== null && props.fieldValues.length > 0) {
        let key = 1;
        let listOptions = props.fieldValues.map((item) => <option key={key++} value={item}>{item}</option>);

        listOptions.unshift(<option key={key} value=''></option>)

        return <select name={props.fieldName}
                       className="form-control"
                       onChange={props.onChangeAttribute}
                       value={value}>
            {listOptions}
        </select>
    }
    else {
        return <input type="text"
                      name={props.fieldName}
                      className="form-control"
                      value={value}
                      onChange={props.onChangeAttribute}
                      disabled={!props.edit_mode}/>;
    }
}

function CreateForViewMode(props) {
    if (props.function_name === 'http_request') {
        if (props.field_name === 'request_header_json') {
            return <KeyValueListEditable variables_json={props.value} edit_mode={false} title_first_column={'Название'} title_second_column={'Значение'}/>
        }
        if (props.field_name === 'result_selector_json') {
            return <KeyValueListEditable variables_json={props.value} edit_mode={false} title_first_column={'Переменная'} title_second_column={'XPath'}/>
        }
        if (props.field_name === 'request_body') {
            let value = props.value
            if (value === '')
                value = '{}';
            return <JsonEditorComponent json={JSON.parse(value)} onChange={props.OnChangeKeyValue} mode={'view'}/>
        }
    }
    return <div>{props.value}</div>
}

class FunctionField extends React.Component {
    constructor(props) {
        super(props);
        this.onChangeValue = this.onChangeValue.bind(this);
        this.onChangeKeyValue = this.onChangeKeyValue.bind(this);
    }


    onChangeValue(e) {
      this.props.onChangeAttribute(this.props.fieldName, e.target.value)
    }

    onChangeKeyValue(keyValueJson) {
        this.props.onChangeAttribute(this.props.fieldName, keyValueJson)
    }

    render() {
        let context = '';

        if (this.props.edit_mode)
            context = <CreateForEditMode fieldValues={this.props.fieldValues}
                                         fieldName={this.props.fieldName}
                                         value={this.props.value}
                                         onChangeAttribute={this.onChangeValue}
                                         OnChangeKeyValue={this.onChangeKeyValue}
                                         edit_mode={this.props.edit_mode}
                                         function_name={this.props.function_name}
                                         field_name={this.props.fieldName}/>;
        else
            context = <CreateForViewMode value={this.props.value} function_name={this.props.function_name} field_name={this.props.fieldName}/>;

        return(
            <React.Fragment>
                <div className="rc-block-item">
                    <div className="rc-block-content" >
                        <div className="rc-editable-field-title">
                            <h2>{this.props.fieldTitle}</h2>
                        </div>
                        {context}
                        <div className="rc-field-hint">{this.props.fieldHint}</div>
                    </div>
                </div>
            </React.Fragment>
    )
    }
}

FunctionField.propTypes = {
    fieldName: PropTypes.string,
    fieldTitle: PropTypes.string,
    fieldValues: PropTypes.array,
    fieldHint: PropTypes.string,
    value: PropTypes.string,
    edit_mode: PropTypes.bool,
    onChangeAttribute: PropTypes.func,
    function_name: PropTypes.string
};

export default FunctionField