import React from 'react';
import PropTypes from 'prop-types';
import {TouchableOpacity} from 'react-native';
import {theme} from '../components/Theme';
import ScrollableContainer from '../components/common/ScrollableContainer';
import Card from '../components/common/Card';
import Search from '../components/common/Search';
import firearmsData from '../../test-data/firearms';
// For now until we decide where data/images come from.
const items = [
  {
    text: 'Firearms',
    path: 'Category',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/firearms.png')
  },
  {
    text: 'Ammunition',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/ammo.jpg')
  },
  {
    text: 'Body armor',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/armor.jpg')
  },
  {
    text: 'Medical',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/medical.png')
  },
  {
    text: 'Melee Weapons',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/melee.jpg')
  },
  {
    text: 'Throwables',
    textPosition: 'bottom left',
    image: require('../../assets/images/card_heroes/throwables.jpg')
  }
];

const ItemsScreen = ({navigation}) => {
  const onPressHandler = (item) => {
    if (item.path) {
      navigation.navigate(item.path, {...item, data: firearmsData});
    } else {
      alert(`${item.text} not yet implemented`);
    }
  };

  return (
    <ScrollableContainer>
      <Search />
      {items.map((item, index) => (
        <TouchableOpacity key={index} onPress={() => onPressHandler(item)}>
          <Card {...item} />
        </TouchableOpacity>
      ))}
    </ScrollableContainer>
  );
};

ItemsScreen.navigationOptions = {
  title: 'Items',
  headerStyle: {
    backgroundColor: theme.colors.almostBlack
  },
  headerTintColor: theme.colors.orange,
  headerTitleStyle: {
    fontSize: 28
  }
};

ItemsScreen.propTypes = {
  navigation: PropTypes.shape({
    navigate: PropTypes.func.isRequired
  }).isRequired
};

export default ItemsScreen;