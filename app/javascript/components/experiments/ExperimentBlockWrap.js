import React from "react"
import Spinner from "../editable_fields/Spinner";
import PropTypes from "prop-types";

class ExperimentBlockWrap extends React.Component {
  render() {
    let spinner = null;

    if (this.props.spinner) {
      spinner = <Spinner/>;
    }

    return (
          <div className={[this.props.title_class_name, 'experiment_block_wrap'].join(' ')}>
            <h4>{this.props.title}</h4>
            {spinner}
            {this.props.children}
          </div>
        );
  }
}

ExperimentBlockWrap.propTypes = {
  title_class_name: PropTypes.string,
  title: PropTypes.string,
  spinner: PropTypes.bool
};
export default ExperimentBlockWrap
