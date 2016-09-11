
sample: dialog {label="ECOFLIGHT";width = 80; 

// GROUP
:radio_row{label="Группа";
:radio_button{label="1"; key="group_1"; value="1";}
:radio_button{label="2"; key="group_2"; value="0";}
:radio_button{label="3"; key="group_3"; value="0";}
:radio_button{label="4"; key="group_4"; value="0";}
:radio_button{label="5"; key="group_5"; value="0";}
} // GROUP

// ACTION
:spacer {height = 1;}
:radio_row{label="Тип полета";
:radio_button{label="взлет"; key="takeoff"; value="1";}
:radio_button{label="посадка"; key="put_down"; value="0";}
} // ACTION


//// CALCULATE 
//:radio_row{label="Calculate";
//:radio_button{label="max"; key="max"; value="1";}
//:radio_button{label="equal"; key="equal"; value="0";}
//} // CALCULATE

:spacer {height = 1;}
// PARAMETERS
:row{label="Параметры для расчета эквивалента"; children_alignment=centered;
:radio_row{label=""; 
:radio_button{label="день"; key="day"; value="1";}
:radio_button{label="ночь"; key="night"; value="0";}
} 

:edit_box{label="Кол-во самолетов       "; key="count"; value="25"; edit_width="8";}
:edit_box{label="Время воздействия          "; key="impact"; value="15"; edit_width="9";}

} // PARAMETERS
:spacer {height = 1;}
//NOISE LEVEL
:column{label="Уровень шума"; 
:paragraph{key="p1";
:concatenation{key="c1";
:text_part{label="Уровень ";}
:text_part{label="        цвет     ";}
:text_part{label="    max ";}
:text_part{label="экв.        ";}
:text_part{label="длина            "; }
:text_part{label="ширина             ";}
:text_part{label="размер           ";}
:text_part{label="текст  ";}
}
}



//:errtile{label="Óðîâåíü         öâåò           ýêâèâàëåíò       äëèíà       øèðèíà           ðàçìåð ";}
:row{label=""; children_alignment=centered;
:toggle{label="  60"; key="db_60"; value="0";}
:image_button {key="clr_60"; color=2;width=5; height=2; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_60"; value="1";}
:radio_button{label=""; key="equal_60"; value="0";}
:edit_box{label=""; key="length_60"; value="100"; edit_width=7;}
:edit_box{label=""; key="width_60"; value="100"; edit_width=7;}
:edit_box{label=""; key="scale_60"; value="35"; edit_width=7;}
:edit_box{label=""; key="text_60"; value="test"; edit_width=7;}
}

:row{label=""; children_alignment=centered;
:toggle{label="  65"; key="db_65"; value="0";}
:image_button {key="clr_65"; color=2;width=5; height=2; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_65"; value="1";}
:radio_button{label=""; key="equal_65"; value="0";}
:edit_box{label=""; key="length_65"; value="100"; edit_width=7;}
:edit_box{label=""; key="width_65"; value="100"; edit_width=7;}
:edit_box{label=""; key="scale_65"; value="35"; edit_width=7;}
:edit_box{label=""; key="text_65"; value="test"; edit_width=7;}
}

:row{label=""; children_alignment=centered;
:toggle{label="  70"; key="db_70"; value="0";}
:image_button {key="clr_70"; color=2;width=5; height=2; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_70"; value="1";}
:radio_button{label=""; key="equal_70"; value="0";}
:edit_box{label=""; key="length_70"; value="100"; edit_width=7;}
:edit_box{label=""; key="width_70"; value="100"; edit_width=7;}
:edit_box{label=""; key="scale_70"; value="30"; edit_width=7;}
:edit_box{label=""; key="text_70"; value="test"; edit_width=7;}
}

:row{label=""; children_alignment=centered;
:toggle{label="  75"; key="db_75"; value="0";}
:image_button {key="clr_75"; color=2;width=5; height=2; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_75"; value="1";}
:radio_button{label=""; key="equal_75"; value="0";}
:edit_box{label=""; key="length_75"; value="100"; edit_width=7;}
:edit_box{label=""; key="width_75"; value="100"; edit_width=7;}
:edit_box{label=""; key="scale_75"; value="30"; edit_width=7;}
:edit_box{label=""; key="text_75"; value="test"; edit_width=7;}
}

:row{label=""; children_alignment=centered;
:toggle{label="  80"; key="db_80"; value="0";}
:image_button {key="clr_80"; color=2;width=5; height=2; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_80"; value="1";}
:radio_button{label=""; key="equal_80"; value="0";}
:edit_box{label=""; key="length_80"; value="100"; edit_width=7;}
:edit_box{label=""; key="width_80"; value="100"; edit_width=7;}
:edit_box{label=""; key="scale_80"; value="25"; edit_width=7;}
:edit_box{label=""; key="text_80"; value="test"; edit_width=7;}
}

:row{label=""; children_alignment=centered;
:toggle{label="  85"; key="db_85"; value="0";}
:image_button {key="clr_85"; color=2;width=5; height=2; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_85"; value="1";}
:radio_button{label=""; key="equal_85"; value="0";}
:edit_box{label=""; key="length_85"; value="100"; edit_width=7;}
:edit_box{label=""; key="width_85"; value="100"; edit_width=7;}
:edit_box{label=""; key="scale_85"; value="25"; edit_width=7;}
:edit_box{label=""; key="text_85"; value="test"; edit_width=7;}
}

:row{label=""; children_alignment=centered;
:toggle{label="  90"; key="db_90"; value="0";}
:image_button {key="clr_90"; color=2;width=5; height=2; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_90"; value="1";}
:radio_button{label=""; key="equal_90"; value="0";}
:edit_box{label=""; key="length_90"; value="100"; edit_width=7;}
:edit_box{label=""; key="width_90"; value="100"; edit_width=7;}
:edit_box{label=""; key="scale_90"; value="20"; edit_width=7;}
:edit_box{label=""; key="text_90"; value="test"; edit_width=7;}
}

:row{label=""; children_alignment=centered;
:toggle{label="  95"; key="db_95"; value="0";}
:image_button {key="clr_95"; color=2;width=5; height=2; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_95"; value="1";}
:radio_button{label=""; key="equal_95"; value="0";}
:edit_box{label=""; key="length_95"; value="100"; edit_width=7;}
:edit_box{label=""; key="width_95"; value="100"; edit_width=7;}
:edit_box{label=""; key="scale_95"; value="20"; edit_width=7;}
:edit_box{label=""; key="text_95"; value="test"; edit_width=7;}
}

:row{label=""; children_alignment=centered;
:toggle{label="100"; key="db_100"; value="0";}
:image_button {key="clr_100"; color=2;width=5; height=2; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_100"; value="1";}
:radio_button{label=""; key="equal_100"; value="0";}
:edit_box{label=""; key="length_100"; value="100"; edit_width=7;}
:edit_box{label=""; key="width_100"; value="100"; edit_width=7;}
:edit_box{label=""; key="scale_100"; value="15"; edit_width=7;}
:edit_box{label=""; key="text_100"; value="test"; edit_width=7;}
}

} // NOISE LEVEL
// CUSTOM NOISE LEVEL
:column{label="Выборочный уровень шума"; 
:row{label=""; children_alignment=centered;
:toggle{label=""; key="db_x_1"; value="0";}
:edit_box{label=""; key="custom_x_1"; value="63"; edit_width=2;}
:image_button {key="clr_x_1"; color=2;width=5; height=2; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_x_1"; value="1";}
:radio_button{label=""; key="equal_x_1"; value="0";}
:edit_box{label=""; key="length_x_1"; value="100"; edit_width=7;}
:edit_box{label=""; key="width_x_1"; value="100"; edit_width=7;}
:edit_box{label=""; key="scale_x_1"; value="20"; edit_width=7;}
:edit_box{label=""; key="text_x_1"; value="test"; edit_width=7;}
}

:row{label=""; children_alignment=centered;
:toggle{label=""; key="db_x_2"; value="0";}
:edit_box{label=""; key="custom_x_2"; value="72"; edit_width=2;}
:image_button {key="clr_x_2"; color=2;width=5; height=2; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_x_2"; value="1";}
:radio_button{label=""; key="equal_x_2"; value="0";}
:edit_box{label=""; key="length_x_2"; value="100"; edit_width=7;}
:edit_box{label=""; key="width_x_2"; value="100"; edit_width=7;}
:edit_box{label=""; key="scale_x_2"; value="20"; edit_width=7;}
:edit_box{label=""; key="text_x_2"; value="test"; edit_width=7;}
}

:row{label=""; children_alignment=centered;
:toggle{label=""; key="db_x_3"; value="0";}
:edit_box{label=""; key="custom_x_3"; value="86"; edit_width=2;}
:image_button {key="clr_x_3"; color=2;width=5; height=2; } 
:spacer {width = 1;}
:radio_button{label=""; key="max_x_3"; value="1";}
:radio_button{label=""; key="equal_x_3"; value="0";}
:edit_box{label=""; key="length_x_3"; value="100"; edit_width=7;}
:edit_box{label=""; key="width_x_3"; value="100"; edit_width=7;}
:edit_box{label=""; key="scale_x_3"; value="20"; edit_width=7;}
:edit_box{label=""; key="text_x_3"; value="test"; edit_width=7;}
}

}// CUSTOM NOISE LEVEL

// MISC
:column{label="Разное"; 
:toggle{label="Соединять впп линиями"; key="merge_vpp"; value="0";}
:toggle{label="Уведомлять о применении ТRIM"; key="notify"; value="0";}
:toggle{label="Автоматически применять ТRIM"; key="auto_trim"; value="0";}
:toggle{label="Удалять временные файлы (типа 73dB.txt)"; key="delete_files"; value="0";}
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