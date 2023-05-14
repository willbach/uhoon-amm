import React, { useState, useEffect } from 'react';
import '../styles/Bog.scss'

interface TradingChartProps {
  isUp: boolean;
}

const TradingChart: React.FC<TradingChartProps> = ({ isUp }) => {
  const [candleHeights, setCandleHeights] = useState<number[]>([]);

  useEffect(() => {
    const min = 10;
    const max = 20;
    const numCandles = Math.floor(Math.random() * 5) + 2;
    const heights = Array(numCandles).fill(0).map((_, i) =>
      i === numCandles - 1 ? Math.random() * (max - min) + 130 : Math.random() * (max - min) + min
    );
    setCandleHeights(heights);
  }, [isUp]);

  const sumPreviousHeights = (index: number) =>
    candleHeights.slice(0, index).reduce((a, b) => a + b, 0);

  return (
    <svg width="200" height="150" xmlns="http://www.w3.org/2000/svg">
      {candleHeights.map((height, i) => (
        <rect
          key={i}
          className={`candle ${isUp ? 'up' : 'down'} ${i === candleHeights.length - 1 ? 'final-candle' : ''}`}
          style={{ animationDelay: `${i * 0.5}s` }}
          x={i * 10}
          y={isUp && i === candleHeights.length - 1 ? 150 - sumPreviousHeights(i) - height : isUp ? 150 - (sumPreviousHeights(i) + height) : sumPreviousHeights(i)}
          width="10"
          height={height}
          fill={isUp ? 'green' : 'red'}
        />
      ))}

      <text
        className={`typewriter ${isUp ? 'up' : 'down'}`}
        style={{ animationDelay: `${candleHeights.length * 0.5}s` }}
        x="0"
        y="290"
        fill={isUp ? 'green' : 'red'}
      >
        {isUp ? 'pump eet.' : 'dump eet.'}
      </text>
    </svg>
  );
};

export default TradingChart;
