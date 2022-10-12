import React from "react"
import PropTypes from "prop-types"

class VariablesEditField extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
                    <div className="inline-form-group">
                        <input type="text" name={'variable_name_' + this.props.row_key} className="form-control field-name" defaultValue={this.props.variable_name}
                               onChange={this.props.onChangeVariable.bind(this)}/>
                        <input type="text" name={'variable_value_' + this.props.row_key} className="form-control field-value" defaultValue={this.props.variable_value}
                               onChange={this.props.onChangeVariable.bind(this)}/>
                        <div><div className='rc-spinner'><i className='fa fa-trash rc-fa-trash' onClick={this.props.on_delete.bind(this, this.props.row_key)} /></div></div>
                    </div>
        )
    }
}

VariablesEditField.propTypes = {
    row_key: PropTypes.string,
    variable_name: PropTypes.string,
    variable_value: PropTypes.string,
    on_delete: PropTypes.func,
    onChangeVariable: PropTypes.func
};

export default VariablesEditField