import React from "react"
import PropTypes from "prop-types"

class VariableField extends React.Component {
    render() {
        if (this.props.edit_mode) {
            return <input type="text" className="form-control" defaultValue={this.props.value}
                          onBlur={(e) => {
                              this.props.onChangeHandler(e.target.value)
                          }}/>
        } else {
            return this.props.value;
        }
    }
}

VariableField.propTypes = {
    edit_mode: PropTypes.bool,
    value: PropTypes.string,
    onChangeHandler: PropTypes.func
};

class KeyValueEditable extends React.Component {
    constructor(props) {
        super(props);
        this.onChangeKeyValue = this.onChangeKeyValue.bind(this);
        this.onChangeValueValue = this.onChangeValueValue.bind(this);
    }

    onChangeKeyValue(value) {
        this.props.onChangeKey(this.props.row_number,value);
    }

    onChangeValueValue(value) {
        this.props.onChangeValue(this.props.row_number,value);
    }

    render() {
        return (
            <tr>
                <td><VariableField edit_mode={this.props.edit_mode} value={this.props.key_name} onChangeHandler={this.onChangeKeyValue}/></td>
                <td><VariableField edit_mode={this.props.edit_mode} value={this.props.value} onChangeHandler={this.onChangeValueValue}/></td>
            </tr>);
    }
}

KeyValueEditable.propTypes = {
    key_name: PropTypes.string,
    value: PropTypes.string,
    onChangeValue: PropTypes.func,
    onChangeKey: PropTypes.func,
    edit_mode: PropTypes.bool,
    row_number: PropTypes.number
};


export default KeyValueEditable