export type CustomizedPieChartLabel = {
  cx: number;
  cy: number;
  midAngle: number;
  innerRadius?: number;
  outerRadius: number;
  startAngle?: number;
  endAngle?: number;
  fill: string;
  payload: Payload["payload"];
  percent: number;
  value?: number;
};

export type CustomizedTooltip = {
  active?: boolean;
  payload?: Payload[];
  label?: string;
};

export type Payload = {
  payload: {
    [key: string]: string | number;
  };
  value: number;
};
