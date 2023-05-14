// @ts-nocheck
// ,annoying svg html type errors
import React from 'react';
import BogBottom from './BogBottom';
import BogTop from './BogTop';
import TradingChart from './TradingChart';

interface BogProps {
  isUp: boolean;
}

const Bogdanoff = ({ isUp }: BogProps) => {
  const ContainerStyle = {
    position: 'relative',
    width: '140px',
    height: '140px',
    overflow: 'none',
  };

  const BogSvgStyles = {
    position: 'absolute',
    top: '0',
    left: '0'
  };

  const FlexContainerStyle = {
    display: 'flex',
    justifyContent: 'space-between',
    gap: '20px', // you can adjust this value to control the space between the components
  };

  const TradingChartStyles = {
    marginTop: '',
  };

  return (
    <div style={FlexContainerStyle}>
      <div style={ContainerStyle}>
        <div style={BogSvgStyles}>
          <BogBottom isUp={isUp} />
          <span style={{ color: isUp ? "#00ff89" : "#CA0000" }}>{isUp ? 'pump eet.' : 'dump eet.'}</span>
        </div>
        <div style={BogSvgStyles}>
          <BogTop />
        </div>
      </div>
      <div style={TradingChartStyles}>
        <TradingChart isUp={isUp} />
      </div>
    </div>
  )
}

export { Bogdanoff, BogBottom, BogTop, TradingChart }
