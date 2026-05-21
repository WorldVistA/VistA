import React from 'react';
import {
  TranslateProps,
  withJsonFormsEnumProps,
  withTranslateProps
} from '@jsonforms/react';
import {
  Unwrapped,
  WithOptionLabel
} from '@jsonforms/material-renderers';
import {
  JsonSchema,
  ControlProps,
  isEnumControl,
  OwnPropsOfEnum,
  RankedTester,
  rankWith,
  schemaMatches,
  and
} from '@jsonforms/core';

const { MaterialEnumControl } = Unwrapped;

type CustomJsonSchema = JsonSchema & {
  "x-piece": number;
}

const PieceEnumControlRenderer =
  (props: ControlProps & OwnPropsOfEnum & WithOptionLabel & TranslateProps) => {
    const { schema, ...otherProps } = props;
    const customSchema = schema as CustomJsonSchema;
    const pieceIndex = customSchema["x-piece"] ? customSchema["x-piece"] - 1 : 0;

    // Check if options is defined and is an array before mapping over it
    const modifiedOptions = Array.isArray(props.options) ? props.options.map((option) => {
      const pieces = option.label.split('^');
      const modifiedLabel = pieces[pieceIndex];
      return {
        ...option,
        label: modifiedLabel, // Use the piece as the label
      };
    }) : props.options;

    // Pass the modified options to MaterialEnumControl
    const enumProps = {
      ...otherProps,
      schema,
      options: modifiedOptions,
    };

    return <MaterialEnumControl {...enumProps} />;
  };

// Tester function to determine when to use the custom enum renderer
const PieceEnumControlTester: RankedTester = rankWith(
  4, // Adjust the rank as needed
  and(
    isEnumControl,
    schemaMatches((schema) => {
      const customSchema = schema as CustomJsonSchema;
      return typeof customSchema["x-piece"] === 'number' && customSchema["x-piece"] >= 1;
    })
  )
);

export default withJsonFormsEnumProps(
  withTranslateProps(React.memo(PieceEnumControlRenderer)),
  false
);

export { PieceEnumControlTester };