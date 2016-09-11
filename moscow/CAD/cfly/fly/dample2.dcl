
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





} // NOISE LEVEL
// CUSTOM NOISE LEVEL
:column{label=""; 
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




:spacer {height = 1;}
// PARAMETERS
:row{label="Анимация"; children_alignment=centered;
:radio_row{label=""; 
:radio_button{label="ON"; key="anim_on"; value="1";}
:radio_button{label="OFF"; key="anim_off"; value="0";}
} 

:edit_box{label="Начальный уровень       "; key="begin_level"; value="60"; edit_width="8";}
:edit_box{label="Конечный уровень          "; key="end_level"; value="65"; edit_width="9";}
:edit_box{label="Шаг    "; key="step_level"; value="1"; edit_width="9";}
} // PARAMETERS

:spacer {height = 1;}

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