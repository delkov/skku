sample: dialog {label="ECOFLIGHT";width = 120; 

//// CALCULATE 
//:radio_row{label="Calculate";
//:radio_button{label="max"; key="max"; value="1";}
//:radio_button{label="equal"; key="equal"; value="0";}
//} // CALCULATE

//NOISE LEVEL
:column{label="Программа расчета шумовых контуров"; 
:paragraph{key="p1";
:concatenation{key="c1";
:text_part{label="   Уровень       ";}
:text_part{label="группа     ";}
:text_part{label="взлет    ";}
:text_part{label="посадка    ";}
:text_part{label="    цвет      ";}
:text_part{label="макс    ";}
:text_part{label="экв.     ";}
:text_part{label="день   ";}
:text_part{label="ночь      ";}
:text_part{label="время     "; }
:text_part{label="кол-во       ";}
:text_part{label="длина      "; }
:text_part{label="ширина      ";}
:text_part{label="размер      ";}
:text_part{label="текст  ";}
}
}

// LEVEL 1
:row{label=""; children_alignment=centered; alignment=left;
:toggle{label=""; key="db_1"; value="0"; edit_height = 3; alignment=centered;}
:edit_box{label=""; key="custom_1"; value="63"; edit_width=2; edit_height = 3; alignment=centered;}
:spacer {width = 0.5;}
:popup_list{key="group_1"; list="1 \n2 \n3 \n4 \n5"; edit_width=3; edit_height = 3;}
:spacer {width = 1;}
:radio_button{label=""; key="takeoff_1"; value="1";edit_height =2;}
:radio_button{label=""; key="put_down_1"; value="0"; edit_height =2;}
:spacer {width = 1;}
:image_button {key="clr_1"; color=2;width=5; height=2.25;alignment=bottom; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_1"; value="1";edit_height =2;}
:radio_button{label=""; key="equal_1"; value="0"; edit_height =2;}
:spacer {width = 2;}
:radio_row{label=""; 
:radio_button{label=""; key="day_1"; value="1";}
:radio_button{label=""; key="night_1"; value="0";}
} 
:spacer {width = 0.5;}
:edit_box{label=""; key="impact_1"; value="15"; edit_width=2;}
:edit_box{label=""; key="count_1"; value="25"; edit_width=2;}
:spacer {width = 2;}
:edit_box{label=""; key="length_1"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="width_1"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="scale_1"; value="20"; edit_width=3;}
:edit_box{label=""; key="text_1"; value="test"; edit_width=7;}
}

// LEVEL 2
:row{label=""; children_alignment=centered; alignment=left;
:toggle{label=""; key="db_2"; value="0"; edit_height = 3; alignment=centered;}
:edit_box{label=""; key="custom_2"; value="63"; edit_width=2; edit_height = 3; alignment=centered;}
:spacer {width = 0.5;}
:popup_list{key="group_2"; list="1 \n2 \n3 \n4 \n5"; edit_width=3; edit_height = 3;}
:spacer {width = 1;}
:radio_button{label=""; key="takeoff_2"; value="1";edit_height =2;}
:radio_button{label=""; key="put_down_2"; value="0"; edit_height =2;}
:spacer {width = 1;}
:image_button {key="clr_2"; color=2;width=5; height=2.25;alignment=bottom; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_2"; value="1";edit_height =2;}
:radio_button{label=""; key="equal_2"; value="0"; edit_height =2;}
:spacer {width = 2;}
:radio_row{label=""; 
:radio_button{label=""; key="day_2"; value="1";}
:radio_button{label=""; key="night_2"; value="0";}
} 
:spacer {width = 0.5;}
:edit_box{label=""; key="impact_2"; value="15"; edit_width=2;}
:edit_box{label=""; key="count_2"; value="25"; edit_width=2;}
:spacer {width = 2;}
:edit_box{label=""; key="length_2"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="width_2"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="scale_2"; value="20"; edit_width=3;}
:edit_box{label=""; key="text_2"; value="test"; edit_width=7;}
}


// LEVEL 3
:row{label=""; children_alignment=centered; alignment=left;
:toggle{label=""; key="db_3"; value="0"; edit_height = 3; alignment=centered;}
:edit_box{label=""; key="custom_3"; value="63"; edit_width=2; edit_height = 3; alignment=centered;}
:spacer {width = 0.5;}
:popup_list{key="group_3"; list="1 \n2 \n3 \n4 \n5"; edit_width=3; edit_height = 3;}
:spacer {width = 1;}
:radio_button{label=""; key="takeoff_3"; value="1";edit_height =2;}
:radio_button{label=""; key="put_down_3"; value="0"; edit_height =2;}
:spacer {width = 1;}
:image_button {key="clr_3"; color=2;width=5; height=2.25;alignment=bottom; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_3"; value="1";edit_height =2;}
:radio_button{label=""; key="equal_3"; value="0"; edit_height =2;}
:spacer {width = 2;}
:radio_row{label=""; 
:radio_button{label=""; key="day_3"; value="1";}
:radio_button{label=""; key="night_3"; value="0";}
} 
:spacer {width = 0.5;}
:edit_box{label=""; key="impact_3"; value="15"; edit_width=2;}
:edit_box{label=""; key="count_3"; value="25"; edit_width=2;}
:spacer {width = 2;}
:edit_box{label=""; key="length_3"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="width_3"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="scale_3"; value="20"; edit_width=3;}
:edit_box{label=""; key="text_3"; value="test"; edit_width=7;}
}

// LEVEL 4
:row{label=""; children_alignment=centered; alignment=left;
:toggle{label=""; key="db_4"; value="0"; edit_height = 3; alignment=centered;}
:edit_box{label=""; key="custom_4"; value="63"; edit_width=2; edit_height = 3; alignment=centered;}
:spacer {width = 0.5;}
:popup_list{key="group_4"; list="1 \n2 \n3 \n4 \n5"; edit_width=3; edit_height = 3;}
:spacer {width = 1;}
:radio_button{label=""; key="takeoff_4"; value="1";edit_height =2;}
:radio_button{label=""; key="put_down_4"; value="0"; edit_height =2;}
:spacer {width = 1;}
:image_button {key="clr_4"; color=2;width=5; height=2.25;alignment=bottom; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_4"; value="1";edit_height =2;}
:radio_button{label=""; key="equal_4"; value="0"; edit_height =2;}
:spacer {width = 2;}
:radio_row{label=""; 
:radio_button{label=""; key="day_4"; value="1";}
:radio_button{label=""; key="night_4"; value="0";}
} 
:spacer {width = 0.5;}
:edit_box{label=""; key="impact_4"; value="15"; edit_width=2;}
:edit_box{label=""; key="count_4"; value="25"; edit_width=2;}
:spacer {width = 2;}
:edit_box{label=""; key="length_4"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="width_4"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="scale_4"; value="20"; edit_width=3;}
:edit_box{label=""; key="text_4"; value="test"; edit_width=7;}
}

// LEVEL 5
:row{label=""; children_alignment=centered; alignment=left;
:toggle{label=""; key="db_5"; value="0"; edit_height = 3; alignment=centered;}
:edit_box{label=""; key="custom_5"; value="63"; edit_width=2; edit_height = 3; alignment=centered;}
:spacer {width = 0.5;}
:popup_list{key="group_5"; list="1 \n2 \n3 \n4 \n5"; edit_width=3; edit_height = 3;}
:spacer {width = 1;}
:radio_button{label=""; key="takeoff_5"; value="1";edit_height =2;}
:radio_button{label=""; key="put_down_5"; value="0"; edit_height =2;}
:spacer {width = 1;}
:image_button {key="clr_5"; color=2;width=5; height=2.25;alignment=bottom; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_5"; value="1";edit_height =2;}
:radio_button{label=""; key="equal_5"; value="0"; edit_height =2;}
:spacer {width = 2;}
:radio_row{label=""; 
:radio_button{label=""; key="day_5"; value="1";}
:radio_button{label=""; key="night_5"; value="0";}
} 
:spacer {width = 0.5;}
:edit_box{label=""; key="impact_5"; value="15"; edit_width=2;}
:edit_box{label=""; key="count_5"; value="25"; edit_width=2;}
:spacer {width = 2;}
:edit_box{label=""; key="length_5"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="width_5"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="scale_5"; value="20"; edit_width=3;}
:edit_box{label=""; key="text_5"; value="test"; edit_width=7;}
}

// LEVEL 6
:row{label=""; children_alignment=centered; alignment=left;
:toggle{label=""; key="db_6"; value="0"; edit_height = 3; alignment=centered;}
:edit_box{label=""; key="custom_6"; value="63"; edit_width=2; edit_height = 3; alignment=centered;}
:spacer {width = 0.5;}
:popup_list{key="group_6"; list="1 \n2 \n3 \n4 \n5"; edit_width=3; edit_height = 3;}
:spacer {width = 1;}
:radio_button{label=""; key="takeoff_6"; value="1";edit_height =2;}
:radio_button{label=""; key="put_down_6"; value="0"; edit_height =2;}
:spacer {width = 1;}
:image_button {key="clr_6"; color=2;width=5; height=2.25;alignment=bottom; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_6"; value="1";edit_height =2;}
:radio_button{label=""; key="equal_6"; value="0"; edit_height =2;}
:spacer {width = 2;}
:radio_row{label=""; 
:radio_button{label=""; key="day_6"; value="1";}
:radio_button{label=""; key="night_6"; value="0";}
} 
:spacer {width = 0.5;}
:edit_box{label=""; key="impact_6"; value="15"; edit_width=2;}
:edit_box{label=""; key="count_6"; value="25"; edit_width=2;}
:spacer {width = 2;}
:edit_box{label=""; key="length_6"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="width_6"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="scale_6"; value="20"; edit_width=3;}
:edit_box{label=""; key="text_6"; value="test"; edit_width=7;}
}

// LEVEL 7
:row{label=""; children_alignment=centered; alignment=left;
:toggle{label=""; key="db_7"; value="0"; edit_height = 3; alignment=centered;}
:edit_box{label=""; key="custom_7"; value="63"; edit_width=2; edit_height = 3; alignment=centered;}
:spacer {width = 0.5;}
:popup_list{key="group_7"; list="1 \n2 \n3 \n4 \n5"; edit_width=3; edit_height = 3;}
:spacer {width = 1;}
:radio_button{label=""; key="takeoff_7"; value="1";edit_height =2;}
:radio_button{label=""; key="put_down_7"; value="0"; edit_height =2;}
:spacer {width = 1;}
:image_button {key="clr_7"; color=2;width=5; height=2.25;alignment=bottom; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_7"; value="1";edit_height =2;}
:radio_button{label=""; key="equal_7"; value="0"; edit_height =2;}
:spacer {width = 2;}
:radio_row{label=""; 
:radio_button{label=""; key="day_7"; value="1";}
:radio_button{label=""; key="night_7"; value="0";}
} 
:spacer {width = 0.5;}
:edit_box{label=""; key="impact_7"; value="15"; edit_width=2;}
:edit_box{label=""; key="count_7"; value="25"; edit_width=2;}
:spacer {width = 2;}
:edit_box{label=""; key="length_7"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="width_7"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="scale_7"; value="20"; edit_width=3;}
:edit_box{label=""; key="text_7"; value="test"; edit_width=7;}
}

// LEVEL 8
:row{label=""; children_alignment=centered; alignment=left;
:toggle{label=""; key="db_8"; value="0"; edit_height = 3; alignment=centered;}
:edit_box{label=""; key="custom_8"; value="63"; edit_width=2; edit_height = 3; alignment=centered;}
:spacer {width = 0.5;}
:popup_list{key="group_8"; list="1 \n2 \n3 \n4 \n5"; edit_width=3; edit_height = 3;}
:spacer {width = 1;}
:radio_button{label=""; key="takeoff_8"; value="1";edit_height =2;}
:radio_button{label=""; key="put_down_8"; value="0"; edit_height =2;}
:spacer {width = 1;}
:image_button {key="clr_8"; color=2;width=5; height=2.25;alignment=bottom; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_8"; value="1";edit_height =2;}
:radio_button{label=""; key="equal_8"; value="0"; edit_height =2;}
:spacer {width = 2;}
:radio_row{label=""; 
:radio_button{label=""; key="day_8"; value="1";}
:radio_button{label=""; key="night_8"; value="0";}
} 
:spacer {width = 0.5;}
:edit_box{label=""; key="impact_8"; value="15"; edit_width=2;}
:edit_box{label=""; key="count_8"; value="25"; edit_width=2;}
:spacer {width = 2;}
:edit_box{label=""; key="length_8"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="width_8"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="scale_8"; value="20"; edit_width=3;}
:edit_box{label=""; key="text_8"; value="test"; edit_width=7;}
}

// LEVEL 9
:row{label=""; children_alignment=centered; alignment=left;
:toggle{label=""; key="db_9"; value="0"; edit_height = 3; alignment=centered;}
:edit_box{label=""; key="custom_9"; value="63"; edit_width=2; edit_height = 3; alignment=centered;}
:spacer {width = 0.5;}
:popup_list{key="group_9"; list="1 \n2 \n3 \n4 \n5"; edit_width=3; edit_height = 3;}
:spacer {width = 1;}
:radio_button{label=""; key="takeoff_9"; value="1";edit_height =2;}
:radio_button{label=""; key="put_down_9"; value="0"; edit_height =2;}
:spacer {width = 1;}
:image_button {key="clr_9"; color=2;width=5; height=2.25;alignment=bottom; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_9"; value="1";edit_height =2;}
:radio_button{label=""; key="equal_9"; value="0"; edit_height =2;}
:spacer {width = 2;}
:radio_row{label=""; 
:radio_button{label=""; key="day_9"; value="1";}
:radio_button{label=""; key="night_9"; value="0";}
} 
:spacer {width = 0.5;}
:edit_box{label=""; key="impact_9"; value="15"; edit_width=2;}
:edit_box{label=""; key="count_9"; value="25"; edit_width=2;}
:spacer {width = 2;}
:edit_box{label=""; key="length_9"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="width_9"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="scale_9"; value="20"; edit_width=3;}
:edit_box{label=""; key="text_9"; value="test"; edit_width=7;}
}

// LEVEL 10
:row{label=""; children_alignment=centered; alignment=left;
:toggle{label=""; key="db_10"; value="0"; edit_height = 3; alignment=centered;}
:edit_box{label=""; key="custom_10"; value="63"; edit_width=2; edit_height = 3; alignment=centered;}
:spacer {width = 0.5;}
:popup_list{key="group_10"; list="1 \n2 \n3 \n4 \n5"; edit_width=3; edit_height = 3;}
:spacer {width = 1;}
:radio_button{label=""; key="takeoff_10"; value="1";edit_height =2;}
:radio_button{label=""; key="put_down_10"; value="0"; edit_height =2;}
:spacer {width = 1;}
:image_button {key="clr_10"; color=2;width=5; height=2.25;alignment=bottom; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_10"; value="1";edit_height =2;}
:radio_button{label=""; key="equal_10"; value="0"; edit_height =2;}
:spacer {width = 2;}
:radio_row{label=""; 
:radio_button{label=""; key="day_10"; value="1";}
:radio_button{label=""; key="night_10"; value="0";}
} 
:spacer {width = 0.5;}
:edit_box{label=""; key="impact_10"; value="15"; edit_width=2;}
:edit_box{label=""; key="count_10"; value="25"; edit_width=2;}
:spacer {width = 2;}
:edit_box{label=""; key="length_10"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="width_10"; value="100"; edit_width=2;}
:spacer {width = 0.25;}
:edit_box{label=""; key="scale_10"; value="20"; edit_width=3;}
:edit_box{label=""; key="text_10"; value="test"; edit_width=7;}
}



//}// CUSTOM NOISE LEVEL

:spacer {height = 1;}
:row{label="Разное"; 
:toggle{label="Соединять впп линиями"; key="merge_vpp"; value="0";}
:toggle{label="Уведомлять о применении ТRIM"; key="notify"; value="0";}
//:toggle{label="Автоматически применять ТRIM"; key="auto_trim"; value="0";}
:toggle{label="Удалять временные файлы"; key="delete_files"; value="0";}
} // MISC

//: image {
//alignment = centered;
//key = "image1";
//width = 50;//100 pixels
//height = 10;//100 pixels
//fixed_width = true;
//fixed_height = true;
//aspect_ratio = 1;
//color = -2;// -15 = no background, -2 = background
//}

ok_cancel;
} // dialog

}