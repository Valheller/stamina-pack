# At the centre of a grave, on the ground: its gravestone (model stamina:grave; the model's y 0 is the ground, so
# it sits half a block up) and a blank name plate on the stone's face, just under the cross (stamina:grave/name).
# Both tagged st.tomb_new, to be turned to face the way the grave does.
summon minecraft:item_display ~ ~ ~ {Tags:["st.tomb_part","st.tomb_new"],width:1f,height:1f,item:{id:"minecraft:polished_andesite",count:1,components:{"minecraft:item_model":"stamina:grave"}},transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],translation:[0f,0.5f,0f],scale:[1f,1f,1f]}}
summon minecraft:text_display ~ ~ ~ {Tags:["st.tomb_part","st.tomb_new","st.tomb_text"],text:"",background:0,line_width:200,transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],translation:[0f,0.24f,0.066f],scale:[0.2f,0.2f,0.2f]}}
