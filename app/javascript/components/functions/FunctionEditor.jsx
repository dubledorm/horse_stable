import React from "react"
import PropTypes from "prop-types"
import SimpleList from "../editable_fields/SimpleList";


class FunctionEditor extends React.Component {
    constructor(props) {
      super(props);
      this.state = {function_name: null};
      this.onChangeFunctionHandler = this.onChangeFunctionHandler.bind(this);
    }

    onChangeFunctionHandler(function_name) {
        this.setState({function_name: function_name});
    }

    render() {
        return(<SimpleList value={this.props.function_names}
                           edit_mode={true}
                           onClickListHandler={this.onChangeFunctionHandler}/>)
    }

}

FunctionEditor.propTypes = {
   function_names: PropTypes.string
};

export default FunctionEditor