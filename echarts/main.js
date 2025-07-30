function getDistrictColor(name) {
  const colorMap = {
    '新城区': '#4ECDC4',
    '碑林区': '#45B7D1',
    '莲湖区': '#96CEB4',
    '灞桥区': '#FFEAA7',
    '未央区': '#DDA0DD',
    '雁塔区': '#98D8C8',
    '阎良区': '#F7DC6F',
    '临潼区': '#BB8FCE',
    '长安区': '#85C1E9',
    '高陵区': '#F8C471',
    '鄠邑区': '#82E0AA',
    '蓝田县': '#F1948A',
    '周至县': '#D7BDE2',
    '高新区': '#A9CCE3',
    '国际港务区': '#F9E79F',
    '经开区': '#D5A6BD',
    '曲江新区': '#A2D9CE',
    '浐灞生态区': '#FAD7A0',
    '其它': '#BFC9CA'
  };
  return colorMap[name] || '#BFC9CA';
}

var myChart = echarts.init(document.getElementById('main'));

let allStreetData = [];
let currentView = 'districts';
let selectedDistrict = null;
let districtOption = null;

function hideBackBtn() {
  document.getElementById('backBtn').style.display = 'none';
}
function showBackBtn() {
  document.getElementById('backBtn').style.display = 'block';
}

fetch('Data/陕西街道.geojson')
  .then(response => response.json())
  .then(geoJson => {
    const xianDistricts = geoJson.features.filter(feature =>
      feature.properties && feature.properties.市 === '西安市' && feature.properties.区
    );

    allStreetData = geoJson.features.filter(feature =>
      feature.properties && feature.properties.市 === '西安市'
    );

    const xianGeoJson = {
      type: 'FeatureCollection',
      features: xianDistricts
    };

    xianGeoJson.features.forEach(feature => {
      if (feature.properties && feature.properties.区) {
        feature.properties.name = feature.properties.区;
      }
    });

    echarts.registerMap('xian_district', xianGeoJson);

    const mapData = xianDistricts.map(feature => {
      const districtName = feature.properties.区 || feature.properties.name || '其它';
      return {
        name: districtName,
        value: 1,
        itemStyle: {
          areaColor: getDistrictColor(districtName)
        }
      };
    });

    districtOption = {
      backgroundColor: '#f7f9fa',
      title: {
        text: '西安市区地图',
        left: 'center',
        top: 32,
        textStyle: {
          fontSize: 22,
          fontWeight: 'bold',
          color: '#222',
          fontFamily: '"Segoe UI", "微软雅黑", Arial, sans-serif'
        }
      },
      tooltip: {
        trigger: 'item',
        backgroundColor: '#222',
        borderRadius: 6,
        textStyle: { color: '#fff', fontSize: 15 },
        formatter: function(params) {
          return params.name || '';
        }
      },
      series: [
        {
          type: 'map',
          map: 'xian_district',
          roam: true,
          label: {
            show: false
          },
          itemStyle: {
            borderColor: '#fff',
            borderWidth: 1
          },
          emphasis: {
            label: {
              show: false
            },
            itemStyle: {
              areaColor: '#b3e5fc',
              borderColor: '#0288d1',
              borderWidth: 2
            }
          },
          data: mapData
        }
      ]
    };
    myChart.setOption(districtOption);

    hideBackBtn();

    myChart.on('click', function(params) {
      const districtName = params.name;
      if (districtName && currentView === 'districts') {
        showDistrictStreets(districtName);
      }
    });
  });

function showDistrictStreets(districtName) {
  const streetsInDistrict = allStreetData.filter(feature => 
    feature.properties && feature.properties.区 === districtName
  );

  if (streetsInDistrict.length > 0) {
    selectedDistrict = districtName;
    currentView = 'streets';

    const streetGeoJson = {
      type: 'FeatureCollection',
      features: streetsInDistrict
    };

    streetGeoJson.features.forEach(feature => {
      if (feature.properties && feature.properties.Name) {
        feature.properties.name = feature.properties.Name;
      }
    });

    echarts.registerMap('street_detail', streetGeoJson);

    const streetData = streetsInDistrict.map(feature => {
      return {
        name: feature.properties.Name || '未知街道',
        value: 1,
        itemStyle: {
          areaColor: '#cccccc',
          borderColor: '#fff',
          borderWidth: 1
        }
      };
    });

    var streetOption = {
      backgroundColor: '#f7f9fa',
      title: {
        text: `${districtName} - 街道详情`,
        left: 'center',
        top: 32,
        textStyle: {
          fontSize: 20,
          fontWeight: 'bold',
          color: '#222',
          fontFamily: '"Segoe UI", "微软雅黑", Arial, sans-serif'
        }
      },
      tooltip: {
        trigger: 'item',
        backgroundColor: '#222',
        borderRadius: 6,
        textStyle: { color: '#fff', fontSize: 14 },
        formatter: function(params) {
          return params.name || '';
        }
      },
      series: [
        {
          type: 'map',
          map: 'street_detail',
          roam: true,
          label: {
            show: true,
            fontSize: 12,
            color: '#333',
            fontWeight: 'bold',
            backgroundColor: 'rgba(255,255,255,0.85)',
            borderRadius: 4,
            padding: [2, 6]
          },
          itemStyle: {
            borderColor: '#fff',
            borderWidth: 1
          },
          emphasis: {
            label: {
              show: true,
              fontSize: 13,
              color: '#fff',
              fontWeight: 'bold',
              backgroundColor: '#0288d1',
              borderRadius: 5,
              padding: [2, 8]
            },
            itemStyle: {
              areaColor: '#b3e5fc',
              borderColor: '#0288d1',
              borderWidth: 2
            }
          },
          data: streetData
        }
      ]
    };

    myChart.setOption(streetOption);

    showBackBtn();

    myChart.off('click');
  }
}

function returnToDistrictView() {
  currentView = 'districts';
  selectedDistrict = null;
  if (districtOption && districtOption.title) {
    districtOption.title = {
      text: '西安市区地图',
      left: 'center',
      top: 32,
      textStyle: {
        fontSize: 22,
        fontWeight: 'bold',
        color: '#222',
        fontFamily: '"Segoe UI", "微软雅黑", Arial, sans-serif'
      }
    };
  }
  myChart.setOption(districtOption, true);

  hideBackBtn();

  myChart.off('click');
  myChart.on('click', function(params) {
    const districtName = params.name;
    if (districtName && currentView === 'districts') {
      showDistrictStreets(districtName);
    }
  });
} 