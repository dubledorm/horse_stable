import React from "react"
import PropTypes from "prop-types"


function CreateForEditMode(props) {
    if (props.fieldValues !== undefined && props.fieldValues !== null && props.fieldValues.length > 0) {
        let key = 1;
        let listOptions = props.fieldValues.map((item) => <option key={key++} value={item}>{item}</option>);

        listOptions.unshift(<option key={key} value=''></option>)

        return <select name={props.fieldName}
                       className="form-control"
                       onChange={props.onChangeAttribute}
                       value={props.value === undefined ? '' : props.value}>
            {listOptions}
        </select>
    }
    else {
        return <input type="text"
                      name={props.fieldName}
                      className="form-control"
                      value={props.value === undefined ? '' : props.value}
                      onChange={props.onChangeAttribute}
                      disabled={!props.edit_mode}/>;
    }
}

function CreateForViewMode(props) {
    return <div>{props.value}</div>
}

class FunctionField extends React.Component {
    constructor(props) {
        super(props);
        this.onChangeValue = this.onChangeValue.bind(this);
    }


    onChangeValue(e) {
      this.props.onChangeAttribute(this.props.fieldName, e.target.value)
    }

    render() {
        let context = '';

        if (this.props.edit_mode)
            context = <CreateForEditMode fieldValues={this.props.fieldValues}
                                         fieldName={this.props.fieldName}
                                         value={this.props.value}
                                         onChangeAttribute={this.onChangeValue}
                                         edit_mode={this.props.edit_mode}/>;
        else
            context = <CreateForViewMode value={this.props.value}/>;

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
    onChangeAttribute: PropTypes.func
};

export default FunctionField