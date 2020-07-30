package com.myself.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.myself.crud.bean.Employee;
import com.myself.crud.bean.Msg;
import com.myself.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author lzq
 * @create 2020-07-28 13:51
 *
 * 处理员工CRUD请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 查询员工信息（分页查询）
     * @return
     */
    //@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){  // pn：PageNumber
        // 默认不是分页查询，此时需要引入pageHelper分页插件
        // 在查询之前调用PageHelper的方法，其后面紧跟的查询就会被解析成分页查询了
        PageHelper.startPage(pn,5);  // 参数：页码、每页大小
        List<Employee> emps = employeeService.getAll();
        // 使用pageInfo包装查询结果，然后将它交给model传到页面即可
        // PageInfo不仅封装了查询结数据，还封装了分页的详细信息
        PageInfo page = new PageInfo(emps,5);  // 参数5：连续显示的页数
        model.addAttribute("pageInfo",page);
        return "list";
    }

    // 以json格式返回数据（前面那个是对象），json传输适用于各平台
    // @ResponseBody要能正常工作，需要导入Jackson包
/*    @RequestMapping("/emps")
    @ResponseBody
    public PageInfo getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn){
        PageHelper.startPage(pn,5);
        List<Employee> emps = employeeService.getAll();
        PageInfo page = new PageInfo(emps,5);
        return page;
    }*/

    // 增强原始要返回的数据，返回自定义的Msg对象，这样返回的json数据更加通用！
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn){
        PageHelper.startPage(pn,5);
        List<Employee> emps = employeeService.getAll();
        PageInfo page = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",page);
    }

    /**
     * 员工保存
     */
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if (result.hasErrors()){
            // 校验失败，应该返回失败信息，在模态框中显示失败的错误信息
            Map<String,Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors) {
                //System.out.println("错误的字段名：" + error.getField());
                //System.out.println("错误信息：" + error.getDefaultMessage());
                map.put(error.getField(),error.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        } else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /**
     * 校验用户名是否可用
     */
    @ResponseBody
    @RequestMapping("/checkuser")
    public Msg checkUser(@RequestParam("empName") String empName){
        // 先判断用户名是否是合法的表达式
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regx)){
            return Msg.fail().add("va_msg","用户名必须是6-16位英文和数字的组合或2-5位的中文！");
        }
        boolean b = employeeService.checkUser(empName);
        if (b){
            return Msg.success();
        } else {
            return Msg.fail().add("va_msg","用户名不可用");
        }
    }

    /**
     * 根据id查询员工
     *  查询一个员工的信息，用来展示在修改页面的
     */
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id){
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }

    /**
     * 员工更新方法
     */
    /*
    // 发送ajax请求保存更新的员工数据
    $.ajax({
        url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
                type:"PUT",  // put
                data:$("#empUpdateModal form").serialize(),
                success:function (result) {
            alert(result.msg);
        }
    });

    以上，ajax直接发put请求，只有路径中的empId会被封装到employee中，其它为null
        [empId=99,empName=null,gender=null,email=null,dId=null]
    浏览器中，观察到请求体有数据，但封装不进employee，会导致后端sql语句发生错误！
        update tbl_emp where emp_id=#{empId}
    明显，set都没有，造成语法错误

    原因是：Tomcat
        1、将请求体中的数据，封装到map中
        2、request.getParameter("empName"); 会从这个map中取出值
        3、springmvc封装pojo对象时，会把pojo中每一个值：request.getParameter("email");

    ajax发送put请求引发的问题：
        put请求，请求体中的数据，request.getParameter("empName");拿不到数据
        tomcat看到是put请求，是不会封装请求体中的数据为map的，只有post请求才会封装进map中！（参看Tomcat源码）
    */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)  // 路径传来的参数需要和employee对象的属性名一致：empId
    public Msg saveEmp(Employee employee, HttpServletRequest request){
        System.out.println(employee);
        System.out.println("email = " + request.getParameter("email"));  // 你会发现得到null，但请求体中却是有值的，拿不到而已!!!
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 单个删除
     *  根据id删除员工
     * @param id
     * @return
     */
/*    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("id") Integer id){
        employeeService.deleteEmp(id);
        return Msg.success();
    }*/

    /**
     * 单个、批量二合一
     *  单个：1
     *  多个：1-2-3
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("ids") String ids){
        // 批量删除
        if (ids.contains("-")){
            List<Integer> del_ids = new ArrayList<>();
            String[] str_ids = ids.split("-");
            // 组装id的集合
            for (String str_id : str_ids) {
                del_ids.add(Integer.parseInt(str_id));
            }
            employeeService.deleteBatch(del_ids);
        } else {  // 单个删除
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }
}
