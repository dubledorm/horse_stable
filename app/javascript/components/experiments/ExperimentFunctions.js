import React from "react";

export function TwoStringWrap(props) {
    return <React.Fragment><h3>
        {props.title + ':'}
    </h3>
        {props.children}
    </React.Fragment>
}

export function OneStringWrap(props) {
    return <div className={'row'}>
        <div className={'col-xs-6 col-md-6'}>
            {props.title + ':'}
        </div>
        {props.children}
    </div>
}

export function OneStringValue(props) {
    return  <OneStringWrap title={props.title}>
        <div className={'col-xs-6 col-md-6'}>
            {props.value}
        </div>
    </OneStringWrap>
}

export function TestTaskShort(props) {
    return <div className={'row'}>
        <div className={'col-xs-6 col-md-6'}>
             <span className={'right'}>
               {props.id == undefined ? '' : props.id + ':'}
             </span>
        </div>

        <div className={'col-xs-6 col-md-6'}>
            {props.start_time}
        </div>
    </div>
}
