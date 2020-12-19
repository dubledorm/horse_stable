import React from "react"
import PropTypes from "prop-types"


function CreateForEditMode(props) {
    if (props.fieldValues !== undefined && props.fieldValues !== null && props.fieldValues.length > 0) {
        let key = 1;
        let listOptions = props.fieldValues.map((item) => <option key={key++} value={item}>{item}</option>);

        listOptions.unshift(<option key={key} value=''></option>)

        return <select name={props.fieldName} className="form-control"
                       defaultValue={props.value}>
            {listOptions}
        </select>
    }
    else {
        return <input type="text"
                      name={props.fieldName}
                      className="form-control"
                      defaultValue={props.value}
                      disabled={!props.edit_mode}/>;
    }
}

function CreateForViewMode(props) {
    return <div>{props.value}</div>
}

class FunctionField extends React.Component {
    constructor(props) {
        super(props);
    }


    render() {
        let context = '';

        if (this.props.edit_mode)
            context = <CreateForEditMode fieldValues={this.props.fieldValues}
                                         fieldName={this.props.fieldName}
                                         value={this.props.value}
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
    edit_mode: PropTypes.bool
};

export default FunctionField