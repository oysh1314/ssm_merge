package com.myself.crud.test;

import com.github.pagehelper.PageInfo;
import com.myself.crud.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * @author lzq
 * @create 2020-07-28 14:32
 *
 * 使用Spring测试模块提供的测试请求功能，验证CRUD请求的正确性！
 * （试试测试模块的一个测试功能好不好用而已！暂时不使用页面来测试，）
 *
 * 另外：Spring4测试，需要servlet 3.0支持
 *      <dependency>
 *       <groupId>javax.servlet</groupId>
 *       <artifactId>javax.servlet-api</artifactId>
 *       <version>3.0.1</version>
 *       <scope>provided</scope>
 *     </dependency>
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml","file:src/main/webapp/WEB-INF/dispatcherServlet-servlet.xml"})  // 红色波浪线错误提示，忽略它不影响结果
@WebAppConfiguration
public class MvcTest {

    // 传入spring的ioc
    @Autowired
    WebApplicationContext context;
    // 虚拟mvc请求，获取到处理结果
    MockMvc mockMvc;

    @Before
    public void initMokcMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        // 模拟请求拿到返回值
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn","10")).andReturn();

        // 请求成功后，请求域中会有pageInfo，我们可以取出进行验证
        MockHttpServletRequest request = result.getRequest();
        PageInfo p = (PageInfo) request.getAttribute("pageInfo");
        System.out.println("当前页面：" + p.getPageNum());
        System.out.println("总页码：" + p.getPages());
        System.out.println("总记录数：" + p.getTotal());
        System.out.println("在页面需要连续显示的页面：");
        int[] nums = p.getNavigatepageNums();
        for (int i : nums) {
            System.out.println(" " + i);
        }
        // 获取员工数据
        List<Employee> list = p.getList();
        for (Employee employee : list) {
            System.out.println("id：" + employee.getEmpId() + " ， name：" + employee.getEmpName());
        }
    }
}
