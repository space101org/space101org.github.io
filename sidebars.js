module.exports = {
  docs: [
    {
      type: 'doc',
      id: 'get-started',
    },
    {
      type: 'doc',
      id: 'kit-assembly',
    },
    {
      type: 'doc',
      id: 'antenna-assembly',
    },
    {
      type: 'category',
      label: 'Приемная станция',
      items: [
        'station/station-about',
        'station/station-firmware',
        'station/station-setup',
        'station/station-decode',
      ],
    },
    {
      type: 'category',
      label: 'Космический аппарат',
      items: [
        'cubesat/cubesat-about',
        'cubesat/cubesat-frame',
		'cubesat/cubesat-electronics',
        'cubesat/cubesat-firmware',
		'cubesat/cubesat-ground',
        'cubesat/cubesat-launch',
      ],
    },
  ],
};
